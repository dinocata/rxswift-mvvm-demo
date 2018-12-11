//
//  CoreDataHelper.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 03/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import CoreData
import RxSwift

/// Provides helper methods for managing Core Data
protocol CoreDataHelper {
    init(coreDataStack: CoreDataStack)
    
    /// Saves all changes to current context
    func saveContext()
    
    /// Returns a single object by its id. Make sure the object has an 'id' property of type Int32.
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - id: id of the object
    /// - Returns: Core data object
    func getObjectById<T: Persistable>(_ type: T.Type, id: Int32) -> Observable<T?>
    
    /// Returns a new NSManagedObject instance of the specified class type contained within the context.
    ///
    /// - Parameter type: Class type of object to be returned
    /// - Returns: New instance of core data object
    func create<T: Persistable>(_ type: T.Type) -> T
    
    /// Tries to find an object of type 'type' by its id.
    /// If it does not exist, creates a new one instead with the specified id.
    /// Make sure the object has an 'id' property of type Int32.
    /// Use this method for saving objects (creating or updating).
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - id: id of an existing object (if it does not exist, returns a new object)
    /// - Returns: New (or existing) core data object
    func getExistingOrNew<T: Persistable>(_ type: T.Type, id: Int32) -> Observable<T>
    
    /// Returns a single object matching specified predicate.
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - predicate: Predicate to be matched by
    /// - Returns: Core data object
    func getObjectBy<T: Persistable>(_ type: T.Type, predicate: NSPredicate?) -> Observable<T?>
    
    /// Returns a list of objects matching specified class type, sorting order and predicate
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - sortDescriptors: Sorting rules
    ///   - predicate: Filtering rules
    /// - Returns: List of core data objects
    func getObjects<T: Persistable>(_ type: T.Type,
                                        sortDescriptors: [NSSortDescriptor],
                                        predicate: NSPredicate?) -> Observable<[T]>
    
    /// Delete an object from Core Data
    ///
    /// - Parameter object: Object to be deleted
    func delete<T: Persistable>(_ object: T)
    
    /// Clears Core Data database
    func deleteAllData()
    
    /// Deletes all core data objects of specified model class
    ///
    /// - Parameter entity: Class type of object to be deleted
    func deleteAllEntities<T: Persistable>(_ entity: T.Type)
}

// Default implementation
extension CoreDataHelper {
    func getObjectBy<T: Persistable>(_ type: T.Type, predicate: NSPredicate? = nil) -> Observable<T?> {
        return getObjectBy(type, predicate: predicate)
    }
    func getObjects<T: Persistable>(_ type: T.Type,
                                        sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: T.defaultSortProperty, ascending: true)],
                                        predicate: NSPredicate? = nil) -> Observable<[T]> {
        return getObjects(type, sortDescriptors: sortDescriptors, predicate: predicate)
    }
}
