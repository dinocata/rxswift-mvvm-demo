//
//  LoginVM.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginVM: ViewModelType {
    
    private let userService: UserService
    private let validationHelper: ValidationHelper
    
    init(userService: UserService, validationHelper: ValidationHelper) {
        self.userService = userService
        self.validationHelper = validationHelper
    }
    
    struct Input {
        var emailInput: TextFieldVM
        var passwordInput: TextFieldVM
        let confirm = PublishSubject<Void>()
    }
    
    struct Output {
        let success: Driver<Void>
        let failure: Driver<String>
        let loading: Driver<Void>
    }
    
    enum LoginEvent {
        case validationSuccess
        case loginSuccess
        case failure(String)
        case loading
        
        static func unknownError() -> LoginEvent {
            return .failure("Unknown error")
        }
        
        func validationSuccessful() -> Bool {
            if case .validationSuccess = self {
                return true
            }
            return false
        }
        
        func loginSuccessful() -> Bool {
            if case .loginSuccess = self {
                return true
            }
            return false
        }
        
        func getErrorMessage() -> String? {
            if case .failure(let errorMessage) = self {
                return errorMessage
            }
            return nil
        }
        
        func isLoading() -> Bool {
            if case .loading = self {
                return true
            }
            return false
        }
    }
    
    func constructLoader(_ eventSource: PublishSubject<Void>, logicDriver: Observable<LoginEvent>) -> Driver<LoginEvent> {
        let delayedLogic = logicDriver
            .delay(0.5, scheduler: MainScheduler.instance)
        
        let loading = eventSource
            .delay(0.05, scheduler: MainScheduler.instance)
            .map { _ in LoginEvent.loading }
        
        let loadingThenData = Observable.merge(loading, delayedLogic)
        
        return logicDriver
            .amb(loadingThenData)
            .filter { $0.isLoading() }
            .asDriver(onErrorJustReturn: .unknownError())
    }
    
    func transform(input: Input) -> Output {
        // Handles local validation
        let validationEventDriver = input.confirm
            .flatMapLatest { [unowned self] in self.validate(input: input) }
            .map { [unowned self] in self.mapValidationResult($0) }
        
        // Handles API login
        let loginEventDriver = validationEventDriver
            .filter { $0.validationSuccessful() }
            .map { [unowned self] _ in self.getLoginRequest(input: input) }
            .flatMap { [unowned self] in self.userService.login($0) }
            .map { [unowned self] in self.mapResponseStatus($0) }
        
        let mergedEvents = Observable.merge(validationEventDriver, loginEventDriver)
        let fullLoginDriver = constructLoader(input.confirm, logicDriver: mergedEvents)
        
        let successDriver = fullLoginDriver
            .filter { $0.loginSuccessful() }
            .map { _ in return }
        
        let failureDriver = fullLoginDriver
            .map { $0.getErrorMessage() }
            .filter { $0 != nil }
            .map { $0! }
        
        let loadingDriver = fullLoginDriver
            .map { $0.isLoading() }
            .distinctUntilChanged()
            .map { _ in return }
        
        return Output(success: successDriver, failure: failureDriver, loading: loadingDriver)
    }
    
}

extension LoginVM {
    
    func validate(input: Input) -> Single<ValidationResult> {
        let emailValidator = Validator()
        emailValidator.format = .email
        input.emailInput.validator = emailValidator
        input.emailInput.label = "Email"
        
        input.passwordInput.validator = Validator()
        input.passwordInput.label = "Password"
        
        return validationHelper.validateInputs([input.emailInput, input.passwordInput])
    }
    
    func getLoginRequest(input: Input) -> LoginRequest {
        return LoginRequest(email: input.emailInput.value.value,
                            password: input.passwordInput.value.value)
    }
    
    func mapValidationResult(_ error: Error) -> LoginEvent {
        if let result = error as? ValidationResult {
            switch result {
            case .success:
                return .validationSuccess
            case .failure(let errorMessage):
                return .failure(errorMessage)
            }
        }
        return .unknownError()
    }
    
    func mapResponseStatus(_ status: ResponseStatus) -> LoginEvent {
        switch status {
        case .success:
            return .loginSuccess
        case .unauthorized:
            return .failure("Wrong password")
        case .notFound:
            return .failure("Email does not exist")
        default:
            return .failure(status.errorDescription)
        }
    }
    
}
