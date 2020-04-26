//
//  StartScreenViewModel.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxCocoa
import Domain

// sourcery: injectable
class StartScreenViewModel {
    private let isUserLoggedInUseCase: IsUserLoggedInUseCase
    private let loginUserUseCase: LoginUserUseCase
    private let logoutUserUseCase: LogoutUserUseCase
    
    init(
        isUserLoggedInUseCase: IsUserLoggedInUseCase,
        loginUserUseCase: LoginUserUseCase,
        logoutUserUseCase: LogoutUserUseCase) {
        self.isUserLoggedInUseCase = isUserLoggedInUseCase
        self.loginUserUseCase = loginUserUseCase
        self.logoutUserUseCase = logoutUserUseCase
    }
}

// Binding
extension StartScreenViewModel: ViewModelType {
    struct Input {
        let dashboardButtonPressed: Driver<Void>
        let loginButtonPressed: Driver<Void>
        let logoutButtonPressed: Driver<Void>
    }
    
    struct Output {
        let isLoggedIn: Driver<Bool>
        let logout: Driver<Void>
        let transition: Driver<Scene>
    }
    
    func transform(input: Input) -> Output {
        let isLoggedIn = isUserLoggedInUseCase.execute()
            .asDriver(onErrorJustReturn: false)
        
        let transition: Driver<Scene> = .merge(
            input.loginButtonPressed.map { .login },
            input.dashboardButtonPressed.map { .postList }
        )
        
        let logout = input.logoutButtonPressed
            .asObservable()
            .flatMapLatest(logoutUserUseCase.execute)
            .mapToVoid()
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            isLoggedIn: isLoggedIn,
            logout: logout,
            transition: transition
        )
    }
}
