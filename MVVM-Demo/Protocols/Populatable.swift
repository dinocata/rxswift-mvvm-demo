//
//  Populatable.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import CoreData

protocol Persistable where Self:NSManagedObject {
    static var defaultSortProperty: String { get }
}

protocol Populatable: Persistable {
    associatedtype DataType: BaseApiResource
    
    func populate(with data: DataType, coreDataHelper: CoreDataHelper) -> Self
}

protocol Identifiable: Populatable {
    var id: Int32 { get set }
}
