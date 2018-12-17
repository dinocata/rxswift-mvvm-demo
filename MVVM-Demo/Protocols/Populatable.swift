//
//  Populatable.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import CoreData

protocol Persistable where Self:NSManagedObject {
    
    /// Specify the name of object primary key field to use when fetching a single object.
    /// This field is also used as a default sorting property.
    /// Make sure this field exists in the Core Data managed object.
    static var identifierName: String { get }
    
    /// Primary key.
    /// Feel free to modify this into a different type (for instance a String), depending on your needs.
    var id: Int32 { get set }
}

extension Persistable where Self:NSManagedObject {
    
    static var identifierName: String {
        return "id"
    }
    
}

protocol Populatable: Persistable {
    
    /// API model associated with this Core Data model
    associatedtype DataType: BaseApiResource
    
    /// Populates a Core Data object with its API model counterpart.
    ///
    /// - Parameters:
    ///   - data: API model data
    ///   - coreDataHelper: For accessing other objects from a Core Data object (used to set up relations)
    /// - Returns: Core Data object instance
    func populate(with data: DataType, coreDataHelper: CoreDataHelper) -> Self
}

