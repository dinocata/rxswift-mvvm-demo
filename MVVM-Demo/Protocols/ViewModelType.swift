//
//  ViewModelType.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

protocol ViewModelType: class {
    associatedtype Input
    associatedtype Output
    
    var coordinator: SceneCoordinatorType { get }
    
    func transform(input: Input) -> Output
}
