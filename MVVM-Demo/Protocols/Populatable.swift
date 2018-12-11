//
//  Populatable.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import CoreData

protocol Persistable where Self:NSManagedObject {
    
    /// Specify the name of object field against which to perform default sort when fetching it.
    /// Needed for using Rx Core Data.
    static var defaultSortProperty: String { get }
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

protocol Identifiable: Populatable {
    
    /// Feel free to modify this into a different type (for instance a String), depending on your needs.
    var id: Int32 { get set }
}
