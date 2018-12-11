//
//  UserDefaultsHelperImpl.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 11/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

final class UserDefaultsHelperImpl: UserDefaultsHelper {
    
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
    
    func clearUserData() {
        do {
            try keychainAccess.resetUserToken()
        } catch {
            print("Could not reset user token")
        }
        setSyncTime(timestamp: 0)
    }
}
