//
//  ValidationHelper.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 04/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift

enum ValidationResult: Error {
    case success
    case failure(String)
}

protocol ValidationHelper {
    func validateInputs(_ inputs: [TextFieldVM]) -> Single<ValidationResult>
}

class ValidationHelperImpl: ValidationHelper {
    
    func validateInputs(_ inputs: [TextFieldVM]) -> Single<ValidationResult> {
        return Single.create(subscribe: { observer -> Disposable in
            var result = ValidationResult.success
            var invalidInput: TextFieldVM?
            
            validationLoop: for input in inputs {
                switch input.validate() {
                case .ok:
                    input.validationResult.onNext(result)
                    
                case .required:
                    let errorMessage = String(format: "validation_required".localized, input.label)
                    result = .failure(errorMessage)
                    invalidInput = input
                    break validationLoop
                    
                case .notAllowed:
                    let errorMessage = String(format: "validation_not_allowed".localized, input.label)
                    result = .failure(errorMessage)
                    invalidInput = input
                    break validationLoop
                    
                case .notNumeric:
                    let errorMessage = String(format: "validation_not_numeric".localized, input.label)
                    result = .failure(errorMessage)
                    invalidInput = input
                    break validationLoop
                    
                case .notInteger:
                    let errorMessage = String(format: "validation_not_integer".localized, input.label)
                    result = .failure(errorMessage)
                    invalidInput = input
                    break validationLoop
                    
                case .notDecimal:
                    let errorMessage = String(format: "validation_not_decimal".localized, input.label)
                    result = .failure(errorMessage)
                    invalidInput = input
                    break validationLoop
                    
                case .valueTooHigh:
                    let formattedMaxValue = (input.validator?.maxValue?.getFormatedString(precision: 0))!
                    let errorMessage = String(format: "validation_value_too_high".localized,
                                              input.label, formattedMaxValue)
                    result = .failure(errorMessage)
                    invalidInput = input
                    break validationLoop
                    
                case .valueTooLow:
                    let formattedMinValue = (input.validator?.minValue?.getFormatedString(precision: 0))!
                    let errorMessage = String(format: "validation_value_too_low".localized,
                                              input.label, formattedMinValue)
                    result = .failure(errorMessage)
                    invalidInput = input
                    break validationLoop
                    
                case .wrongFormat:
                    let errorMessage = String(format: "validation_wrong_format".localized, input.label)
                    result = .failure(errorMessage)
                    invalidInput = input
                    break validationLoop
                    
                case let .custom(errorMessage):
                    result = .failure(errorMessage)
                    invalidInput = input
                    break validationLoop
                    
                default:
                    let errorMessage = String(format: "validation_general".localized, input.label)
                    result = .failure(errorMessage)
                    invalidInput = input
                    break validationLoop
                }
            }
            
            if let invalidInput = invalidInput {
                invalidInput.validationResult.onNext(result)
            }
            
            observer(.success(result))
            
            return Disposables.create()
        })
    }
    
}
