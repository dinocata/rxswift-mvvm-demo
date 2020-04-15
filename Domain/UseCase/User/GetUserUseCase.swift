//
//  GetUserUseCase.swift
//  Domain
//
//  Created by Dino Catalinac on 15/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift

// sourcery: injectable
public protocol GetUserUseCase {
    func execute() -> Observable<User>
}

public class GetUserUseCaseImpl: GetUserUseCase {
    
    public var userRepository: UserRepository!
    
    public init() {}
    
    public func execute() -> Observable<User> {
        return userRepository.getCurrentUser()
    }
}
