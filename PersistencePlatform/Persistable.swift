//
//  Persistable.swift
//  PersistencePlatform
//
//  Created by Dino Catalinac on 14/12/2019.
//  Copyright © 2019 DinoCata. All rights reserved.
//

import CoreData

/// Represents Core Data model
public protocol Persistable where Self: NSManagedObject {
    associatedtype DomainType
    
    var identifier: String? { get set }
    var serverId: Int32 { get set }
    var synced: Bool { get set }
    var softDeleted: Bool { get set }
    var dateUpdated: Date? { get set }
    
    func asDomain() -> DomainType
    func populate(with data: DomainType, coreDataManager: CoreDataManager)
}

extension Persistable {
    
    static var identifierName: String { return "identifier" }
    static var serverIdName: String { return "serverId" }
    
    public static var defaultSortDescriptor: [NSSortDescriptor] {
        return [NSSortDescriptor(key: identifierName, ascending: true)]
    }
}
