//
//  ViewModelType.swift
//  PresentationPlatform
//
//  Created by Dino Catalinac on 14/12/2019.
//  Copyright © 2019 DinoCata. All rights reserved.
//

import Foundation

/// https://medium.com/blablacar-tech/rxswift-mvvm-66827b8b3f10
public protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
