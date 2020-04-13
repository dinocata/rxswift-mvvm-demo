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
    // Dependencies
}

// Binding
extension StartScreenViewModel: ViewModelType {
    struct Input {
        let dashboardButtonPressed: Driver<Void>
        let loginButtonPressed: Driver<Void>
        let loginEventReceived: Driver<LoginEvent>
    }
    
    struct Output {
        let showLogin: Driver<Void>
        let transition: Driver<Scene>
    }
    
    func transform(input: Input) -> Output {
        return Output(
            showLogin: input.loginButtonPressed,
            transition: input.dashboardButtonPressed.map { .dashboard }
        )
    }
}
