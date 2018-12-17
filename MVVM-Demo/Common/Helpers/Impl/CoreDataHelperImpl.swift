//
//  CoreDataHelperImpl.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 11/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import CoreData
import RxSwift

class CoreDataHelperImpl: CoreDataHelper {
    
    private let coreDataStack: CoreDataStack
    
    required init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func saveContext() {
        coreDataStack.saveContext()
    }
    
    func getObjectById<T: Persistable>(_ type: T.Type, id: Int32) -> Observable<T?> {
        let predicate = NSPredicate(format: "\(T.identifierName) = %d", id)
        return getObjects(type, predicate: predicate).map { $0.first }
    }
    
    func create<T: Persistable>(_ type: T.Type) -> T {
        let context = coreDataStack.context
        let entity = NSEntityDescription.entity(forEntityName: String(describing: type), in: context)!
        return type.init(entity: entity, insertInto: context)
    }
    
    func getExistingOrNew<T: Persistable>(_ type: T.Type, id: Int32) -> Observable<T> {
        let result = getObjectById(type, id: id)
        let existingResult = result
            .filter { $0 != nil }
            .map { $0! }
        
        let newResult = result
            .filter { $0 == nil}
            .mapToVoid()
            .flatMap { [unowned self] in Observable.just(self.create(type))}
        
        return existingResult.amb(newResult)
    }
    
    func getObjectBy<T: Persistable>(_ type: T.Type, predicate: NSPredicate? = nil) -> Observable<T?> {
        return getObjects(type, predicate: predicate).map { $0.first }
    }
    
    func getObjects<T: Persistable>(_ type: T.Type,
                                    sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: T.identifierName, ascending: true)],
                                    predicate: NSPredicate? = nil) -> Observable<[T]> {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: type))
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        return coreDataStack.context.rx.entities(fetchRequest: fetchRequest)
    }
    
    func delete<T: Persistable>(_ object: T) {
        coreDataStack.context.delete(object)
    }
    
    func deleteAllData() {
        deleteAllEntities(Article.self)
    }
    
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
