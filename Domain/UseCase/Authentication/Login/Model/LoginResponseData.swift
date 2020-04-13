//
//  LoginResponseData.swift
//  Domain
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Foundation

public struct LoginResponseData: Decodable {
    let token: String
    let userId: Int32
    let email: String
}
