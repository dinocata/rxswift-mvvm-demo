//
//  ViewModelType.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

/// https://medium.com/blablacar-tech/rxswift-mvvm-66827b8b3f10
protocol ViewModelType: class {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
