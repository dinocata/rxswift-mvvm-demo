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
    
    public var authRepository: AuthRepository!
    
    public init() {}
    
    public func execute() -> Completable {
        return authRepository.logout()
    }
}
