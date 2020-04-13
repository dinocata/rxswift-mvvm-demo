//
//  Mapper.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Foundation

protocol Mapper {
    associatedtype Resource
    associatedtype Data
    
    func map(from resource: Resource) -> Data
}
