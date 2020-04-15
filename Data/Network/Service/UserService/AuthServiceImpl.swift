//
//  UserServiceImpl.swift
//  Data
//
//  Created by Dino Catalinac on 15/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift
import Domain

public class AuthServiceImpl: AuthService {
    
    public var network: NetworkProtocol!
    
    public init() {}
    
    public func login(using credentials: LoginRequestData) -> Single<NetworkResult<LoginResponseData>> {
        return network.request(.login(request: credentials))
    }
}
