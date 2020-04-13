//
//  LoginUseCase.swift
//  Domain
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 UHP. All rights reserved.
//

import RxSwift

// sourcery: injectable
public protocol LoginUseCase {
    func login(email: String, password: String) -> Single<NetworkResult<LoginResponseData>>
}

public class LoginUseCaseImpl: LoginUseCase {

    public var authRepository: AuthRepository!
    
    public init() {}
    
    public func login(email: String, password: String) -> Single<NetworkResult<LoginResponseData>> {
        let credentials = LoginRequestData(
            email: email,
            password: password
        )
        
        return authRepository.login(using: credentials)
    }
}
