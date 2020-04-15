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
    var isUserLoggedInUseCase: IsUserLoggedInUseCase!
    var loginUserUseCase: LoginUserUseCase!
    var logoutUserUseCase: LogoutUserUseCase!
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
            input.dashboardButtonPressed.map { .dashboard }
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
