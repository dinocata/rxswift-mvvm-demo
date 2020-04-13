//
//  AuthRepositoryImpl.swift
//  Data
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift
import Domain

public class AuthRepositoryImpl: AuthRepository {
    
    public init() {}
    
    public func login(using credentials: LoginRequestData) -> Single<NetworkResult<LoginResponseData>> {
        // TODO: Add implementation
        return .just(.failure(.badGateway))
    }
}
