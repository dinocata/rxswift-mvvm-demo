//
//  CoreDataStack.swift
//  PersistencePlatform
//
//  Created by Dino Catalinac on 14/12/2019.
//  Copyright © 2019 DinoCata. All rights reserved.
//

import CoreData

private let persistentContainerName = "mvvm-rxswift-demo"

// sourcery: factory = CoreDataStackImpl, singleton
public protocol CoreDataStack {
    var persistentContainer: NSPersistentContainer { get }
    
    /// Executes and saves any context changes in a single synchronous operation queue.
    /// This ensures that  there are no merge conflicts between different contexts.
    /// https://stackoverflow.com/a/42745378/8249743
    func enqueue(block: @escaping (_ context: NSManagedObjectContext) -> Void)
    
    /// Relevant when doing Batch deletes.
    /// Batch deletes are only available when you are using a SQLite persistent store.
    /// https://developer.apple.com/library/archive/featuredarticles/CoreData_Batch_Guide/BatchDeletes/BatchDeletes.html
    func isPersistentStore() -> Bool
    
    /// Forcefully saves changes to the main context
    func saveContext()
}

public class CoreDataStackImpl: CoreDataStack {
    
    lazy public var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: persistentContainerName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
            }
        })
        return container
    }()
    
    lazy var persistentContainerQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    public init() {}
    
    public func enqueue(block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainerQueue.addOperation {
            let context = self.persistentContainer.newBackgroundContext()
            context.performAndWait {
                block(context)
                self.saveChanges(for: context)
            }
        }
    }
    
    public func isPersistentStore() -> Bool {
        return true
    }
    
    public func saveContext() {
        saveChanges(for: persistentContainer.viewContext)
    }
    
    private func saveChanges(for context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace with more appropriate error handler.
                fatalError(error.localizedDescription)
            }
        }
    }
}

class CoreDataStackMock: CoreDataStack {
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: persistentContainerName,
                                              managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                // Replace with more appropriate error handler.
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application.
        let modelURL = Bundle.main.url(forResource: persistentContainerName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    func enqueue(block: @escaping (NSManagedObjectContext) -> Void) {
        let context = persistentContainer.viewContext
        block(context)
        try? context.save()
    }
    
    func saveContext() {
        try? persistentContainer.viewContext.save()
    }
    
    func isPersistentStore() -> Bool {
        return false
    }
}
