//
//  SaveUserUseCase.swift
//  Domain
//
//  Created by Dino Catalinac on 15/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Foundation

// sourcery: injectable
public protocol SaveUserUseCase {
    func execute(user: User)
}

public class SaveUserUseCaseImpl: SaveUserUseCase {
    
    public var userRepository: UserRepository!
    
    public init() {}
    
    public func execute(user: User) {
        userRepository.saveUser(user)
    }
}
