//
//  AuthRepository.swift
//  Domain
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift

// sourcery: injectable
public protocol AuthRepository {
    func login(using credentials: LoginRequestData) -> Single<NetworkResult<LoginResponseData>>
}
