//
//  CoreDataManager.swift
//  PersistencePlatform
//
//  Created by Dino Catalinac on 14/12/2019.
//  Copyright © 2019 DinoCata. All rights reserved.
//

import CoreData

// sourcery: factory = CoreDataManagerImpl, singleton
public protocol CoreDataManager {
    /// Returns a new NSManagedObject instance of the specified class type contained within the context.
    ///
    /// - Parameter type: Class type of object to be returned
    /// - Returns: New instance of core data object
    func create<T: Persistable>(_ type: T.Type, context: NSManagedObjectContext) -> T
    
    /// Syncs and saves current core data representable object to Core Data persistence, matched by their local id's.
    /// If the object does not exist, creates and saves a new one.
    ///
    /// - Parameter entity: Object to sync
    /// - Returns: Core Data observable object
    func syncByLocalId<C: BaseModel, P>(entity: C,
                                        context: NSManagedObjectContext) -> P where P == C.CoreDataType, C == P.DomainType
    
    /// Syncs and saves current core data representable object to Core Data persistence, matched by their server id's.
    /// If the object does not exist, creates and saves a new one.
    ///
    /// - Parameter entity: Object to sync
    /// - Returns: Core Data observable object
    func syncByServerId<C: BaseModel, P>(entity: C,
                                         context: NSManagedObjectContext) -> P where P == C.CoreDataType, C == P.DomainType
    
    /// Tries to find an object of type 'type' by its id.
    /// If it does not exist, creates a new one instead with the specified id.
    /// Make sure the object has an 'id' property of type Int32.
    /// Use this method for saving objects (creating or updating).
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - uid: id of an existing object (if it does not exist, returns a new object)
    /// - Returns: New (or existing) core data object
    func getExistingOrNew<C: BaseModel, P>(entity: C,
                                           context: NSManagedObjectContext) -> P where P == C.CoreDataType, C == P.DomainType
    
    /// Should be self explanatory
    func getServerExistingOrNew<C: BaseModel, P>(entity: C,
                                                 context: NSManagedObjectContext) -> P where P == C.CoreDataType, C == P.DomainType
    
    /// Returns a single object by its id.
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - id: id of the object
    /// - Returns: Core data object
    func findById<T: Persistable>(_ type: T.Type, id: String, context: NSManagedObjectContext) -> T?
    
    /// Should be self explanatory
    func findByServerId<T: Persistable>(_ type: T.Type, id: Int32, context: NSManagedObjectContext) -> T?
    
    /// Returns a single object matching specified predicate.
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - predicate: Predicate to be matched by
    /// - Returns: Core data object
    func findFirst<T: Persistable>(_ type: T.Type, predicate: NSPredicate?, context: NSManagedObjectContext) -> T?
    
    /// Returns a list of objects matching specified class type, sorting order and predicate.
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - sortDescriptors: Sorting rules
    ///   - predicate: Filtering rules
    /// - Returns: List of core data objects
    func findAll<T: Persistable>(_ type: T.Type,
                                 sortDescriptors: [NSSortDescriptor],
                                 predicate: NSPredicate?,
                                 fetchLimit: Int,
                                 context: NSManagedObjectContext) -> [T]
    
    /// Delete an object from Core Data.
    ///
    /// - Parameter object: Object to be deleted.
    func delete<T: Persistable>(_ object: T, context: NSManagedObjectContext)
    
    /// Delete list of objects from Core Data.
    ///
    /// - Parameter objects: Objects to delete.
    func delete<T: Persistable>(_ objects: [T], context: NSManagedObjectContext)
    
    /// Clears Core Data database.
    func deleteAllData(context: NSManagedObjectContext)
    
    /// Deletes all core data objects of specified model class.
    /// Does not work for mocked core data contexts.
    ///
    /// - Parameter entity: Class type of object to be deleted.
    func deleteAllEntities<T: Persistable>(entity: T.Type, context: NSManagedObjectContext)
}

extension CoreDataManager {
    func findAll<T: Persistable>(_ type: T.Type,
                                 sortDescriptors: [NSSortDescriptor] = T.defaultSortDescriptor,
                                 predicate: NSPredicate?,
                                 fetchLimit: Int = 0,
                                 context: NSManagedObjectContext) -> [T] {
        return findAll(type, sortDescriptors: sortDescriptors, predicate: predicate, fetchLimit: fetchLimit, context: context)
    }
}

public class CoreDataManagerImpl: CoreDataManager {
    
    public init() {}
    
    public func create<T: Persistable>(_ type: T.Type, context: NSManagedObjectContext) -> T {
        let entity = NSEntityDescription.entity(forEntityName: String(describing: type), in: context)!
        let object = type.init(entity: entity, insertInto: context)
        object.identifier = object.objectID.uriRepresentation().lastPathComponent
        return object
    }
    
    public func syncByLocalId<C: BaseModel, P>(entity: C, context: NSManagedObjectContext) -> P where P == C.CoreDataType, C == P.DomainType {
        let object = getExistingOrNew(entity: entity, context: context)
        object.populate(with: entity, coreDataManager: self)
        return object
    }
    
    public func syncByServerId<C: BaseModel, P>(entity: C, context: NSManagedObjectContext) -> P where P == C.CoreDataType, C == P.DomainType {
        let object = getServerExistingOrNew(entity: entity, context: context)
        object.populate(with: entity, coreDataManager: self)
        return object
    }
    
    public func getExistingOrNew<C: BaseModel, P>(entity: C, context: NSManagedObjectContext) -> P where P == C.CoreDataType, C == P.DomainType {
        return findById(P.self, id: entity.localId ?? "noid", context: context) ?? create(P.self, context: context)
    }
    
    public func getServerExistingOrNew<C: BaseModel, P>(entity: C, context: NSManagedObjectContext) -> P where P == C.CoreDataType, C == P.DomainType {
        return findByServerId(P.self, id: entity.id ?? -1, context: context) ?? create(P.self, context: context)
    }
    
    public func findById<T: Persistable>(_ type: T.Type, id: String, context: NSManagedObjectContext) -> T? {
        let predicate = NSPredicate(format: "\(T.identifierName) = %@", id)
        return findFirst(type, predicate: predicate, context: context)
    }
    
    public func findByServerId<T>(_ type: T.Type, id: Int32, context: NSManagedObjectContext) -> T? where T: Persistable {
        let predicate = NSPredicate(format: "\(T.serverIdName) = %i", id)
        return findFirst(type, predicate: predicate, context: context)
    }
    
    public func findFirst<T: Persistable>(_ type: T.Type, predicate: NSPredicate?, context: NSManagedObjectContext) -> T? {
        return findAll(type, predicate: predicate, fetchLimit: 1, context: context).first
    }
    
    public func findAll<T: Persistable>(_ type: T.Type,
                                        sortDescriptors: [NSSortDescriptor],
                                        predicate: NSPredicate?,
                                        fetchLimit: Int,
                                        context: NSManagedObjectContext) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: type))
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        if fetchLimit > 0 {
            fetchRequest.fetchLimit = fetchLimit
        }
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            // Replace with more appropriate error handler.
            fatalError(error.localizedDescription)
        }
    }
    
    public func delete<T: Persistable>(_ object: T, context: NSManagedObjectContext) {
        context.delete(object)
    }
    
    public func delete<T: Persistable>(_ objects: [T], context: NSManagedObjectContext) {
        objects.forEach { delete($0, context: context) }
    }
    
    public func deleteAllData(context: NSManagedObjectContext) {
        // NOOP
    }
    
    public func deleteAllEntities<T: NSManagedObject>(entity: T.Type, context: NSManagedObjectContext) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entity))
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(request)
        } catch {
            // Replace with more appropriate error handler.
            fatalError(error.localizedDescription)
        }
        context.reset()
    }
}
