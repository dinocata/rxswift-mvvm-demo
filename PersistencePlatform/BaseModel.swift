//
//  BaseModel.swift
//  PersistencePlatform
//
//  Created by Dino Catalinac on 14/12/2019.
//  Copyright © 2019 DinoCata. All rights reserved.
//

import CoreData

/// Represents Domain model
public protocol BaseModel: Codable {
    associatedtype CoreDataType: Persistable
    
    // Local persistence id
    var localId: String? { get set }
    
    // Server/API id
    var id: Int32? { get set }
    
    //static var notificationName: Notification.Name { get }
    
    func getCDObject(using coreDataManager: CoreDataManager, context: NSManagedObjectContext) -> CoreDataType?
}

extension BaseModel {
    static var typeName: String { return String(describing: self) }
    
    /// Associates a notification name with this data type.
    /// This notification is sent when data is updated.
    /// Nil by default (no notification is sent).
    static var notificationName: Notification.Name { return Notification.Name(typeName) }
}
