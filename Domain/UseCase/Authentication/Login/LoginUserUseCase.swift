//
//  LoginUseCase.swift
//  Domain
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 UHP. All rights reserved.
//

import RxSwift

// sourcery: injectable, AutoMockable
public protocol LoginUserUseCase {
    func execute(email: String, password: String) -> Single<NetworkResult<User>>
}

public class LoginUserUseCaseImpl: LoginUserUseCase {
    
    public var authRepository: AuthRepository!
    public var saveUserUseCase: SaveUserUseCase!
    
    public init() {}
    
    public func execute(email: String, password: String) -> Single<NetworkResult<User>> {
        let requestData = LoginRequestData(
            email: email, password: password
        )
        
        return authRepository.login(using: requestData)
            .map { [weak self] result in
                switch result {
                case .success(let data):
                    let user = User(email: email, type: .normal)
                    self?.authRepository.setAuthToken(data.token)
                    self?.saveUserUseCase.execute(user: user)
                    return .success(user)
                    
                case .failure(let error):
                    return .failure(error)
                }
        }
    }
}
