//
//  ValidatorHelper.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ValidatorHelper {
    typealias ValidationResult = (valid: Bool, errorMessage: String?, source: Driver<String>)
}
