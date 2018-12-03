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
    private let coordinator: SceneCoordinatorType
    
    init(userService: UserService, coordinator: SceneCoordinatorType) {
        self.userService = userService
        self.coordinator = coordinator
    }
    
    struct Input {
        let emailInput: InputWrapper
        let passwordInput: InputWrapper
        let confirm: Driver<Void>
    }
    
    struct Output {
        let success: Driver<Void>
        let failure: Driver<String>
        let loading: Driver<Bool>
    }
    
    enum LoginEvent {
        case success
        case loading
        case failure(String)
    }
    
    func transform(input: Input) -> Output {
        let loginEventDriver = input.confirm
            .asObservable()
            .flatMap { [unowned self] in
                self.userService.login(LoginRequest(email: "test", password: "test"))
            }
            .asDriver(onErrorJustReturn: .unrecognized)
        
        let successDriver = loginEventDriver
            .filter { $0 == .success }
            .map { _ in return }
        
        let failureDriver = loginEventDriver
            .filter { $0 != .success && $0 != .loading }
            .map { status -> String in
                switch status {
                case .unauthorized: return "Wrong password"
                case .notFound: return "Email does not exist"
                default: return status.errorDescription
                }
        }
        
        let loadingDriver = loginEventDriver
            .map { $0 == .loading }
        
        return Output(success: successDriver, failure: failureDriver, loading: loadingDriver)
    }
    
}
