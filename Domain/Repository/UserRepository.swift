//
//  AuthRepository.swift
//  Domain
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift

// sourcery: injectable, AutoMockable
public protocol UserRepository {
    func getCurrentUser() -> Observable<User>
    func saveUser(_ user: User)
}
