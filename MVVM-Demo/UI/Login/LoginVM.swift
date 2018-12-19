//
//  LoginVM.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginVM {
    
    private let userService: UserService
    private let validationHelper: ValidationHelper
    
    init(userService: UserService, validationHelper: ValidationHelper) {
        self.userService = userService
        self.validationHelper = validationHelper
    }
    
    func constructLoader(_ eventSource: Observable<Void>, events: Observable<FormEvent>) -> Driver<FormEvent> {
        // Show loader as soon as button is pressed
        let loading = eventSource.map { FormEvent.loading }
        return Observable.merge(loading, events).asDriver(onErrorJustReturn: .unknownError())
    }
    
}

extension LoginVM: ViewModelType {
    
    struct Input {
        var emailInput: TextFieldVM
        var passwordInput: TextFieldVM
        let confirm: Driver<Void>
    }
    
    struct Output {
        let success: Driver<Void>
        let failure: Driver<String>
        let loading: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        // Handles local validation
        let validationEventDriver = input.confirm
            .asObservable()
            .flatMapLatest { [unowned self] in self.validate(input: input) }
            .map { [unowned self] in self.mapValidationResult($0) }
        
        // Handles API login
        let loginEventDriver = validationEventDriver
            .filter { $0.validationSuccessful() }
            .mapToVoid()
            .map { [unowned self] in self.getLoginRequest(input: input) }
            .flatMap { [unowned self] in self.userService.login($0) }
            .map { [unowned self] in self.mapResponseStatus($0) }
        
        // Merge events so both errors from failed validation and login can be reacted to
        let mergedEvents = Observable.merge(validationEventDriver, loginEventDriver)
            .filter { !$0.validationSuccessful() }
            .share()
        
        // Adds a progress loader
        let fullLoginDriver = constructLoader(input.confirm.asObservable(), events: mergedEvents)
        
        let successDriver = fullLoginDriver
            .filter { $0.isSuccessful() }
            .mapToVoid()
        
        let failureDriver = fullLoginDriver
            .map { $0.getErrorMessage() }
            .filter { $0 != nil }
            .map { $0! }
        
        let loadingDriver = fullLoginDriver
            .filter { $0.isLoading() }
            .mapToVoid()
        
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
    
    func mapValidationResult(_ result: ValidationResult) -> FormEvent {
        switch result {
        case .success:
            return .validationSuccess
        case .failure(let errorMessage):
            return .failure(errorMessage)
        }
    }
    
    func mapResponseStatus(_ status: ResponseStatus) -> FormEvent {
        switch status {
        case .success:
            return .success
        case .unauthorized:
            return .failure("Wrong password")
        case .notFound:
            return .failure("Email does not exist")
        default:
            return .failure(status.errorDescription)
        }
    }
    
}
