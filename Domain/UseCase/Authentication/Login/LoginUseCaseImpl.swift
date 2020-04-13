//
//  LoginUseCaseImpl.swift
//  Domain
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 UHP. All rights reserved.
//

import Foundation

public class LoginUseCaseImpl: LoginUseCase {
    public func login(username: String, password: String) {
        print("TEST: \(username)-\(password)")
    }
}
