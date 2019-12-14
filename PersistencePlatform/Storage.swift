//
//  Storage.swift
//  PersistencePlatform
//
//  Created by Dino Catalinac on 14/12/2019.
//  Copyright © 2019 DinoCata. All rights reserved.
//

import CoreData
import RxSwift

protocol AbstractStorage {
    associatedtype DomainType: BaseModel
    
    // Local interface
    
    /// Retrieves an entity by its identifier.
    func findById(_ identifier: String) -> Observable<DomainType?>
    
    /// Returns the fist entity that matches the specified predicate.
    ///
    /// - Parameter predicate: Predicate to be matched with
    /// - Returns: Single entity
    func findFirst(with predicate: NSPredicate?) -> Observable<DomainType?>
    
    /// Finds all entities that match the specified predicate and sorts them accordingly.
    ///
    /// - Parameters:
    ///   - predicate: Predicate to be matched with
    ///   - sortDescriptors: Sorting rules
    /// - Returns: List of entities
    func findAll(with predicate: NSPredicate?,
                 sortDescriptors: [NSSortDescriptor]) -> Observable<[DomainType]>
    
    /// Creates or updates an entity to the local persistence and marks it for syncing.
    ///
    /// - Parameter entity: Entity to be saved
    func save(entity: DomainType) -> Observable<DomainType>
    
    /// Creates or updates entities to the local persistence and marks it for syncing.
    ///
    /// - Parameter entities: Entities to be saved
    func save(entities: [DomainType]) -> Observable<Void>
    
    /// Sets a softDeleted flag on an entity and marks it for syncing.
    /// This entity remains in the local persistence
    /// as long as still exists on the server.
    ///
    /// - Parameter entity: Entity to be soft deleted
    func softDelete(entity: DomainType) -> Observable<Void>
    
    /// Performs soft delete on a list of entities.
    ///
    /// - Parameter entities: Entities to be soft deleted.
    func softDelete(entities: [DomainType]) -> Observable<Void>
    
    /// Permanently deletes specified entity from local persistence.
    ///
    /// - Parameter entity: Entity to be deleted.
    func delete(entity: DomainType) -> Observable<Void>
    
    /// Permanently deletes specified entities from local persistence.
    ///
    /// - Parameter entities: Entities to be deleted
    func delete(entities: [DomainType]) -> Observable<Void>
    
    /// Permanently deletes all objects of this Domain type from local persistence.
    func deleteAll() -> Observable<Void>
    
    /// Executes thread safe context block. Optionally returns data wrapped in an observable when finished.
    func performContextExecution<T>(_ block: @escaping (_ context: NSManagedObjectContext) -> T) -> Observable<T>
    
    /// Executes and saves any context changes in a single synchronous operation queue.
    func performContextModification<T>(_ block: @escaping (_ context: NSManagedObjectContext) -> T) -> Observable<T>
    
    /// Triggers an associated notification for this data type.
    /// Useful for reacting to changes on data update.
    func notify()
}

extension AbstractStorage {
    func findAll(with predicate: NSPredicate?,
                 sortDescriptors: [NSSortDescriptor] = DomainType.CoreDataType.defaultSortDescriptor)
        -> Observable<[DomainType]> {
            return findAll(with: predicate, sortDescriptors: sortDescriptors)
    }
}

class Storage<T: BaseModel>: AbstractStorage where T == T.CoreDataType.DomainType {
    
    var coreDataManager: CoreDataManager!
    var coreDataStack: CoreDataStack!
    var notificationManager: NotificationManager!
    
    var changeNotifier: Observable<Void> {
        return notificationManager.register(notification: T.notificationName)
            .share()
            .throttle(0.1, scheduler: MainScheduler.instance)
            .map { _ in }
            .startWith(())
    }
    
    var mainContext: NSManagedObjectContext {
        return coreDataStack.persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        return coreDataStack.persistentContainer.newBackgroundContext()
    }
    
    var threadBasedContext: NSManagedObjectContext {
        if Thread.isMainThread {
            return mainContext
        }
        return backgroundContext
    }
    
    func findById(_ identifier: String) -> Observable<T?> {
        return changeNotifier.map { self.findById(identifier) }
    }
    
    func findFirst(with predicate: NSPredicate?) -> Observable<T?> {
        return changeNotifier.map { self.findFirst(with: predicate) }
    }
    
    func findAll(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]) -> Observable<[T]> {
        return changeNotifier.map { self.findAll(with: predicate, sortDescriptors: sortDescriptors) }
    }
    
    func save(entity: T) -> Observable<T> {
        return performContextModification {
            let object = self.coreDataManager.syncByLocalId(entity: entity, context: $0)
            object.synced = false
            object.softDeleted = false
            object.dateUpdated = Date()
            return object.asDomain()
        }
    }
    
    func save(entities: [T]) -> Observable<Void> {
        return performContextModification { context in
            entities.forEach {
                let object = self.coreDataManager.syncByLocalId(entity: $0, context: context)
                object.synced = false
                object.softDeleted = false
                object.dateUpdated = Date()
            }
        }
    }
    
    func softDelete(entity: T) -> Observable<Void> {
        // If object does not exist on the API, we can delete it permanently
        if entity.id == nil {
            return delete(entity: entity)
        }
        
        return performContextModification {
            if let object = entity.getCDObject(using: self.coreDataManager, context: $0) {
                object.softDeleted = true
                object.synced = false
                object.dateUpdated = Date()
            }
        }
    }
    
    func softDelete(entities: [T]) -> Observable<Void> {
        return performContextModification { context in
            entities
                .compactMap { $0.getCDObject(using: self.coreDataManager, context: context) }
                .forEach {
                    $0.softDeleted = true
                    $0.synced = false
                    $0.dateUpdated = Date()
            }
        }
    }
    
    func delete(entity: T) -> Observable<Void> {
        return performContextModification {
            if let object = entity.getCDObject(using: self.coreDataManager, context: $0) {
                self.coreDataManager.delete(object, context: $0)
            }
        }
    }
    
    func delete(entities: [T]) -> Observable<Void> {
        return performContextModification { context in
            entities
                .compactMap { $0.getCDObject(using: self.coreDataManager, context: context) }
                .forEach { self.coreDataManager.delete($0, context: context) }
        }
    }
    
    func deleteAll() -> Observable<Void> {
        return performContextModification {
            self.coreDataManager.deleteAllEntities(entity: T.CoreDataType.self, context: $0) }
            // Deleting all entities is an immediate effect and does not retain a changed state in the context,
            // so we have to manually notify for changes, since notify is only called on context save.
            .do(onNext: { self.notify() })
    }
    
    func findById(_ identifier: String) -> T? {
        return coreDataManager
            .findById(T.CoreDataType.self, id: identifier, context: mainContext)?
            .asDomain()
    }
    
    func findFirst(with predicate: NSPredicate?) -> T? {
        let compoundPredicate = buildPredicate(predicate: predicate)
        return coreDataManager
            .findFirst(T.CoreDataType.self, predicate: compoundPredicate, context: mainContext)?
            .asDomain()
    }
    
    func findAll(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]) -> [T] {
        let compoundPredicate = buildPredicate(predicate: predicate)
        return coreDataManager
            .findAll(T.CoreDataType.self,
                     sortDescriptors: sortDescriptors,
                     predicate: compoundPredicate,
                     context: mainContext)
            .map { $0.asDomain() }
    }
    
    private func buildPredicate(predicate: NSPredicate?) -> NSPredicate {
        var predicates = [NSPredicate(format: "softDeleted = %d", false)]
        if let predicate = predicate { predicates.append(predicate) }
        return NSCompoundPredicate(type: .and, subpredicates: predicates)
    }
    
    func performContextExecution<T>(_ block: @escaping (_ context: NSManagedObjectContext) -> T) -> Observable<T> {
        return .create { observer in
            let context = self.threadBasedContext
            context.perform {
                observer.onNext(block(context))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func performContextModification<T>(_ block: @escaping (_ context: NSManagedObjectContext) -> T) -> Observable<T> {
        return .create { observer in
            self.coreDataStack.enqueue(block: { context in
                self.addContextSaveObserver(for: context)
                observer.onNext(block(context))
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    private func addContextSaveObserver(for context: NSManagedObjectContext) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onContextSave),
                                               name: .NSManagedObjectContextDidSave,
                                               object: context)
    }
    
    @objc private func onContextSave(notification: Notification) {
        if let context = notification.object as? NSManagedObjectContext {
            DispatchQueue.main.async {
                self.mainContext.mergeChanges(fromContextDidSave: notification)
                NotificationCenter.default.removeObserver(self, name: .NSManagedObjectContextDidSave, object: context)
                self.notify()
            }
        }
    }
    
    func notify() {
        notificationManager.post(notification: T.notificationName, object: nil)
    }
}
