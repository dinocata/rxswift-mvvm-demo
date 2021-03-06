//
//  LoginViewModel.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxCocoa
import Domain

// sourcery: injectable
class LoginViewModel {
    private let loginUserUseCase: LoginUserUseCase
    private let mapper: LoginViewDataMapper
    
    init(loginUserUseCase: LoginUserUseCase, mapper: LoginViewDataMapper) {
        self.loginUserUseCase = loginUserUseCase
        self.mapper = mapper
    }
}

extension LoginViewModel: ViewModelType {
    struct Input {
        let email: Driver<String>
        let password: Driver<String>
        let submit: Driver<Void>
        let closeButtonPressed: Driver<Void>
    }
    
    struct Output {
        let submitEnabled: Driver<Bool>
        let loading: Driver<Bool>
        let failure: Driver<String>
        let close: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let credentials = Driver.combineLatest(
            input.email,
            input.password
        )
        
        let request = input.submit
            .withLatestFrom(credentials)
            .asObservable()
            .flatMapLatest(loginUserUseCase.execute)
            .share()
        
        let success = request
            .filter { $0.value != nil }
            .mapToVoid()
            .asDriver(onErrorJustReturn: ())
        
        let failure = request
            .compactMap { $0.error }
            .map(mapper.mapLoginError)
            .asDriver(onErrorJustReturn: "-")
        
        let loading = Driver.merge(
            input.submit.map { _ in true },
            request.map { _ in false }.asDriver(onErrorJustReturn: false)
        )
        
        let close = Driver.merge(
            success,
            input.closeButtonPressed
        )
        
        return Output(
            submitEnabled: credentials.map { !$0.0.isEmpty && !$0.1.isEmpty },
            loading: loading,
            failure: failure,
            close: close
        )
    }
}
