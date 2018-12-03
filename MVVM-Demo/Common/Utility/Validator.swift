//
//  Validator.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

class Validator {
    
    enum Result {
        case ok
        case required
        case notNumeric
        case notInteger
        case notDecimal
        case wrongFormat
        case lengthTooHigh
        case lengthTooLow
        case valueTooHigh
        case valueTooLow
        case notAllowed
        case custom(errorMessage: String)
        
        var valid: Bool {
            switch self {
            case .ok:
                return true
            default:
                return false
            }
        }
    }
    
    // Predefined regex formats. Add any extra cases you may need.
    enum InputFormat: String {
        case alphanumeric = "^[A-Za-z0-9- ]+$"
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
    
    var required: Bool = true
    var integer: Bool = false
    var decimal: Bool = false
    var format: InputFormat?
    var maxLength: Int?
    var minLength: Int?
    var maxValue: Float?
    var minValue: Float?
    var allowedValues: [String]?
    var disallovedValues: [String]?
    var customCondition: ((String?) -> Result)?
    
    // If this condition is met, the validation will always pass
    var successCondition: ((String?) -> Bool)?
    
    // Returns string representation of the input
    private(set) var stringValue = ""
    // Returns integer representation of the input
    private(set) var intValue: Int?
    // Returns float representation of the input
    private(set) var floatValue: Float?
    
    /// Performs validation on the provided text string
    ///
    /// - Parameter input: Text to validate
    /// - Returns: Validation result
    func validate(input: String?) -> Result {
        
        if let successCondition = self.successCondition,
            successCondition(input) {
            return .ok
        }
        
        if let customCondition = self.customCondition {
            let customConditionResult = customCondition(input)
            if !customConditionResult.valid {
                return customConditionResult
            }
        }
        
        guard let input = input else {
            if required {
                return .required
            } else {
                return .ok
            }
        }
        
        self.stringValue = input
        
        if input.isEmpty {
            if required {
                return .required
            } else {
                return .ok
            }
        }
        
        if integer {
            if let intValue = Int(input) {
                self.intValue = intValue
            } else {
                return .notInteger
            }
        }
        
        if decimal {
            if let floatValue = input.numberValue?.floatValue {
                self.floatValue = floatValue
            } else {
                return .notDecimal
            }
        }
        
        if let minLength = self.minLength {
            if input.count < minLength {
                return .lengthTooLow
            }
        }
        
        if let maxLength = self.maxLength {
            if input.count > maxLength {
                return .lengthTooHigh
            }
        }
        
        if let minValue = self.minValue {
            if let floatValue = floatValue ?? input.numberValue?.floatValue {
                self.floatValue = floatValue
                if floatValue < minValue {
                    return .valueTooLow
                }
            } else {
                return .notNumeric
            }
        }
        
        if let maxValue = self.maxValue {
            if let floatValue = floatValue ?? input.numberValue?.floatValue {
                self.floatValue = floatValue
                if floatValue > maxValue {
                    return .valueTooHigh
                }
            } else {
                return .notNumeric
            }
        }
        
        if let format = self.format {
            let predicate = NSPredicate(format:"SELF MATCHES %@", format.rawValue)
            if !predicate.evaluate(with: input) {
                return .wrongFormat
            }
        }
        
        if let allowedValues = self.allowedValues {
            if !allowedValues.contains(input) {
                return .notAllowed
            }
        }
        
        if let disallowedValues = self.disallovedValues {
            if disallowedValues.contains(input) {
                return .notAllowed
            }
        }
        
        return .ok
    }
    
}
