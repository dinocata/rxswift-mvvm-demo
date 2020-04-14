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
    
    public var authService: AuthService!
    public var keychainAccess: KeychainAccessManager!
    
    public init() {}
    
    public func login(using credentials: LoginRequestData) -> Single<NetworkResult<Void>> {
        return authService.login(using: credentials)
    }
    
    public func isUserLoggedIn() -> Observable<Bool> {
        return keychainAccess
            .getAuthToken()
            .map { $0 != nil }
    }
    
    public func logout() -> Completable {
        return .create { [weak self] completable in
            self?.keychainAccess.authToken = nil
            completable(.completed)
            return Disposables.create()
        }
    }
}
