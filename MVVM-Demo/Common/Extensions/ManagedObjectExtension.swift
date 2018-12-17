//
//  ManagedObjectExtension.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 17/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import CoreData

extension NSManagedObject {
    
    /// Attempts to populate the Core Data object using key-value pairs of a codable object.
    ///
    /// - Parameter data: Codable data
    /// - Throws: In case of non-matching keys, value types etc.
    func quickPopulate<T: Encodable>(data: T) throws {
        try setValuesForKeys(data.asDictionary())
    }
    
}
