//
//  LoginRequestData.swift
//  Domain
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Foundation

public struct LoginRequestData: Encodable {
    let email: String
    let password: String
}
