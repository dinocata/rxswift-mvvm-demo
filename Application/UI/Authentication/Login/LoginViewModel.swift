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
    var useCase: LoginUseCase!
}

extension LoginViewModel: ViewModelType {
    struct Input {
        let closeButtonPressed: Driver<Void>
    }
    
    struct Output {
        let close: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let close = Driver.merge(
            input.closeButtonPressed
        )
        
        return Output(close: close)
    }
}
