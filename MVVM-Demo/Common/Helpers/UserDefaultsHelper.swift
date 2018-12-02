//
//  UserDefaults.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

protocol UserDefaultsHelper {
    func isUserLoggedIn() -> Bool
    func isUserDataSynced() -> Bool
    func getSyncTime() -> Int
    func setSyncTime(timestamp: Int)
}

class UserDefaultsHelperImpl: UserDefaultsHelper {
 
    private let keychainAccess: KeychainAccessHelper
    
    init(keychainAccess: KeychainAccessHelper) {
        self.keychainAccess = keychainAccess
    }
    
    func isUserLoggedIn() -> Bool {
        return keychainAccess.getUserToken() != nil
    }
    
    func isUserDataSynced() -> Bool {
        return getSyncTime() > 0
    }
    
    func getSyncTime() -> Int {
        return UserDefaults.standard.integer(forKey: Constants.UserDefaultsKeys.syncTime)
    }
    
    func setSyncTime(timestamp: Int) {
        UserDefaults.standard.set(timestamp, forKey: Constants.UserDefaultsKeys.syncTime)
    }
}
