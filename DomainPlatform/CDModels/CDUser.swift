//
//  CDUser.swift
//  DomainPlatform
//
//  Created by Dino Catalinac on 14/12/2019.
//  Copyright © 2019 DinoCata. All rights reserved.
//

import PersistencePlatform

extension CDUser: Persistable {
    
    public func asDomain() -> User {
        return User(localId: identifier,
                    id: serverId,
                    firstName: firstName,
                    lastName: lastName)
    }
    
    public func populate(with data: User, coreDataManager: CoreDataManager) {
        serverId = data.id ?? serverId
        firstName = data.firstName ?? firstName
        lastName = data.lastName ?? lastName
    }
}
