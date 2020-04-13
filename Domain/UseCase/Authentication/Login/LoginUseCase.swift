//
//  LoginUseCase.swift
//  Domain
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 UHP. All rights reserved.
//

import Foundation

// sourcery: AutoMockable
public protocol LoginUseCase {
    func login(username: String, password: String)
}
