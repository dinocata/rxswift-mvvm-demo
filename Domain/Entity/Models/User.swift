//
//  User.swift
//  Domain
//
//  Created by Dino Catalinac on 15/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Foundation

public struct User: Codable {
    public let email: String?
    public let type: UserType
    
    public init(email: String?, type: UserType) {
        self.email = email
        self.type = type
    }
}
