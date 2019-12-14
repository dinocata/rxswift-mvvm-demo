//
//  User.swift
//  DomainPlatform
//
//  Created by Dino Catalinac on 14/12/2019.
//  Copyright © 2019 DinoCata. All rights reserved.
//

import CoreData
import PersistencePlatform

public struct User: BaseModel {
    public var localId: String?
    public var id: Int32?
    public var firstName: String?
    public var lastName: String?
}

extension User {
    public func getCDObject(using coreDataManager: CoreDataManager, context: NSManagedObjectContext) -> CDUser? {
        return coreDataManager.findById(CDUser.self, id: self.localId ?? "noid", context: context)
    }
}
