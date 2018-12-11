//
//  CoreDataStack.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 03/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import CoreData

/// This helper provides instance to Core Data managed object context.
protocol CoreDataStack {
    var context: NSManagedObjectContext { get }
    
    func saveContext()
}
