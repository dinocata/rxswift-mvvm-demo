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
    
    func saveContext()
    func getObjectById<T: Persistable>(_ type: T.Type, id: Int32) -> Observable<T?>
    func create<T: Persistable>(_ type: T.Type) -> T
    func getExistingOrNew<T: Persistable>(_ type: T.Type, id: Int32) -> Observable<T>
    func getObjectBy<T: Persistable>(_ type: T.Type, predicate: NSPredicate?) -> Observable<T?>
    func getObjects<T: Persistable>(_ type: T.Type,
                                        sortDescriptors: [NSSortDescriptor],
                                        predicate: NSPredicate?) -> Observable<[T]>
    func delete<T: Persistable>(_ object: T)
    func deleteAllData()
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

class CoreDataHelperImpl: CoreDataHelper {
    
    private let coreDataStack: CoreDataStack
    
    required init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    /// Saves all changes to current context
    func saveContext() {
        coreDataStack.saveContext()
    }
    
    /// Returns a single object by its id. Make sure the object has an 'id' property of type Int32.
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - id: id of the object
    /// - Returns: Core data object
    func getObjectById<T: Persistable>(_ type: T.Type, id: Int32) -> Observable<T?> {
        let predicate = NSPredicate(format: "id = %d", id)
        return getObjects(type, predicate: predicate).map { $0.first }
    }
    
    /// Returns a new NSManagedObject instance of the specified class type contained within the context.
    ///
    /// - Parameter type: Class type of object to be returned
    /// - Returns: New instance of core data object
    func create<T: Persistable>(_ type: T.Type) -> T {
        let context = coreDataStack.context
        let entity = NSEntityDescription.entity(forEntityName: String(describing: type), in: context)!
        return type.init(entity: entity, insertInto: context)
    }
    
    /// Tries to find an object of type 'type' by its id.
    /// If it does not exist, creates a new one instead with the specified id.
    /// Make sure the object has an 'id' property of type Int32.
    /// Use this method for saving objects (creating or updating).
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - id: id of an existing object (if it does not exist, returns a new object)
    /// - Returns: New (or existing) core data object
    func getExistingOrNew<T: Persistable>(_ type: T.Type, id: Int32) -> Observable<T> {
        let result = getObjectById(type, id: id)
        let existingResult = result
            .filter { $0 != nil }
            .map { $0! }
        
        let newResult = result
            .filter { $0 == nil}
            .mapToVoid()
            .flatMap { [unowned self] object -> Observable<T?> in
                let newObject = self.create(type)
                newObject.setValue(id, forKey: "id")
                return self.getObjectById(type, id: id)
            }
            .map { $0! }
        
        return existingResult.amb(newResult)
    }
    
    /// Returns a single object matching specified predicate.
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - predicate: Predicate to be matched by
    /// - Returns: Core data object
    func getObjectBy<T: Persistable>(_ type: T.Type, predicate: NSPredicate? = nil) -> Observable<T?> {
        return getObjects(type, predicate: predicate).map { $0.first }
    }
    
    /// Returns a list of objects matching specified class type, sorting order and predicate
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - sortDescriptors: Sorting rules
    ///   - predicate: Filtering rules
    /// - Returns: List of core data objects
    func getObjects<T: Persistable>(_ type: T.Type,
                                        sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: T.defaultSortProperty, ascending: true)],
                                        predicate: NSPredicate? = nil) -> Observable<[T]> {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: type))
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        return coreDataStack.context.rx.entities(fetchRequest: fetchRequest).distinctUntilChanged()
    }
    
    /// Delete an object from Core Data
    ///
    /// - Parameter object: Object to be deleted
    func delete<T: Persistable>(_ object: T) {
        coreDataStack.context.delete(object)
    }
    
    /// Clears Core Data database
    func deleteAllData() {
        // Call deleteAllEntities on all your entities here
        // E.g. deleteAllEntities(Article.self)
    }
    
    /// Deletes all core data objects of specified model class
    ///
    /// - Parameter entity: Class type of object to be deleted
    func deleteAllEntities<T: Persistable>(_ entity: T.Type) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entity))
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try coreDataStack.context.execute(request)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}
