//
//  AuthService.swift
//  Data
//
//  Created by Dino Catalinac on 14/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift
import Domain

// sourcery: injectable, singleton
public protocol AuthService {
    func login(using credentials: LoginRequestData) -> Single<NetworkResult<LoginResponseData>>
}
