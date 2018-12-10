//
//  FetchedResultsControllerEntityObserver.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 10/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//
// https://github.com/sergdort/CleanArchitectureRxSwift/blob/master/CoreDataPlatform/RxCoreData/FetchedResultsControllerEntityObserver.swift

import CoreData
import RxSwift

final class FetchedResultsControllerEntityObserver<T: NSFetchRequestResult> : NSObject, NSFetchedResultsControllerDelegate {
    
    typealias Observer = AnyObserver<[T]>
    
    fileprivate let observer: Observer
    fileprivate let frc: NSFetchedResultsController<T>
    
    init(observer: Observer, fetchRequest: NSFetchRequest<T>, managedObjectContext context: NSManagedObjectContext, sectionNameKeyPath: String?, cacheName: String?) {
        self.observer = observer
        
        
        self.frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: sectionNameKeyPath,
                                              cacheName: cacheName)
        super.init()
        
        context.perform {
            self.frc.delegate = self
            
            do {
                try self.frc.performFetch()
            } catch let e {
                observer.on(.error(e))
            }
            
            self.sendNextElement()
        }
    }
    
    fileprivate func sendNextElement() {
        self.frc.managedObjectContext.perform {
            let entities = self.frc.fetchedObjects ?? []
            self.observer.on(.next(entities))
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sendNextElement()
    }
}

extension FetchedResultsControllerEntityObserver : Disposable {
    
    public func dispose() {
        frc.delegate = nil
    }
    
}
