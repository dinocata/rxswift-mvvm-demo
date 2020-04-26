//
//  AuthRepositoryImpl.swift
//  Data
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift
import Domain

public class UserRepositoryImpl: UserRepository {
    
    private let userDefaults: UserDefaultsManager
    private let keychainAccess: KeychainAccessManager
    
    public init(userDefaults: UserDefaultsManager, keychainAccess: KeychainAccessManager) {
        self.userDefaults = userDefaults
        self.keychainAccess = keychainAccess
    }
    
    public func getCurrentUser() -> Observable<User> {
        let combine = Observable.combineLatest(
            userDefaults.observeDecodable(type: User.self, key: UserDefaultsManagerImpl.Keys.currentUser),
            keychainAccess.getAuthToken()
        )
        
        return combine.map { user, token in
            User(email: user?.email, type: token != nil ? .normal : .offline)
        }
    }
    
    // Since we do not have Core Data storage implemented yet, we will just store the user data in user defaults
    public func saveUser(_ user: User) {
        userDefaults.storeEncodable(user, key: UserDefaultsManagerImpl.Keys.currentUser)
    }
}
