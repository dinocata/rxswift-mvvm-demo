//
//  TextFieldVM.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 04/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift
import RxCocoa

/// Wraps a text field UI control in a bindable View Model (used for validating text fields).
class TextFieldVM {
    let value = BehaviorRelay(value: "")
    var label: String = ""
    var validationResult = PublishSubject<ValidationResult>()
    var validator: Validator?
    
    func validate() -> Validator.Result {
        guard let validator = validator else {
            return .ok
        }
        return validator.validate(input: value.value)
    }
}
