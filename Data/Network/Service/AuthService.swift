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
    func login(using credentials: LoginRequestData) -> Single<NetworkResult<Void>>
}

public class AuthServiceImpl: AuthService {
    
    public var network: NetworkProtocol!
    public var keychainAccess: KeychainAccessManager!
    
    public init() {}
    
    public func login(using credentials: LoginRequestData) -> Single<NetworkResult<Void>> {
        return network.request(.login(request: credentials), responseType: LoginResponseData.self)
            .map { [weak self] result in
                switch result {
                case .success(let data):
                    self?.keychainAccess.authToken = data.token
                    return .success(())
                    
                case .failure(let error):
                    return .failure(error)
                }
        }
    }
}
