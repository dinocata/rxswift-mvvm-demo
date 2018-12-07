//
//  Populatable.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

protocol Populatable {
    associatedtype DataType: Decodable
    
    func populate(with data: DataType) -> Self
}
