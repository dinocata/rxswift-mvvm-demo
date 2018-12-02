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
    
    private let coordinator: SceneCoordinatorType
    
    init(coordinator: SceneCoordinatorType) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let emailText: Driver<String>
        let passwordText: Driver<String>
        let confirm: Driver<Void>
    }
    
    struct Output {
        let success: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let success = input.confirm
            .map { return }
            .asDriver()
        
        return Output(success: success)
    }
    
}
