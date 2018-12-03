//
//  InputWrapper.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 03/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift
import RxCocoa

class InputWrapper {
    
    let value: Driver<String>
    var label: String?
    var validator: Validator?
    
    init(value: Driver<String>) {
        self.value = value
    }
    
    func validate() -> Observable<Validator.Result> {
        guard let validator = validator else {
            return Observable.just(.ok)
        }
        return value.asObservable()
            .flatMap { Observable.just(validator.validate(input: $0)) }
    }
}
