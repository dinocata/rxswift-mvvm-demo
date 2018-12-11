//
//  ValidationHelper.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 04/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift

enum ValidationResult {
    case success
    case failure(String)
}

/// A helper class for performing quick text field validation.
protocol ValidationHelper {
    
    /// Iterates through all text fields wrapped in Text Field view models and performs validation check on them.
    ///
    /// - Parameter inputs: Text field view models to validate
    /// - Returns: Validation result enum (either success or failure with message)
    func validateInputs(_ inputs: [TextFieldVM]) -> Single<ValidationResult>
}
