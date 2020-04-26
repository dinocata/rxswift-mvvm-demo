//
//  LogoutUserUseCase.swift
//  Domain
//
//  Created by Dino Catalinac on 15/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift

// sourcery: injectable, AutoMockable
public protocol LogoutUserUseCase {
    func execute() -> Completable
}

public class LogoutUserUseCaseImpl: LogoutUserUseCase {
    
    private let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func execute() -> Completable {
        return authRepository.logout()
    }
}
