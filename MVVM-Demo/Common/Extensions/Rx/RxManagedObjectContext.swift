//
//  RxManagedObjectContext.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 10/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import CoreData
import RxSwift

extension Reactive where Base: NSManagedObjectContext {
    
    /**
     Executes a fetch request and returns the fetched objects as an `Observable` array of `NSManagedObjects`.
     - parameter fetchRequest: an instance of `NSFetchRequest` to describe the search criteria used to retrieve data from a persistent store
     - parameter sectionNameKeyPath: the key path on the fetched objects used to determine the section they belong to; defaults to `nil`
     - parameter cacheName: the name of the file used to cache section information; defaults to `nil`
     - returns: An `Observable` array of `NSManagedObjects` objects that can be bound to a table view.
     */
    func entities<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>,
                                           sectionNameKeyPath: String? = nil,
                                           cacheName: String? = nil) -> Observable<[T]> {
        return Observable.create { observer in
            
            let observerAdapter = FetchedResultsControllerEntityObserver(observer: observer,
                                                                         fetchRequest: fetchRequest,
                                                                         managedObjectContext: self.base,
                                                                         sectionNameKeyPath: sectionNameKeyPath,
                                                                         cacheName: cacheName)
            
            return Disposables.create {
                observerAdapter.dispose()
            }
        }
    }
}
