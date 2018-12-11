//
//  KeychainAccessHelperImpl.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 11/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation
import KeychainAccess

final class KeychainAccessHelperImpl: KeychainAccessHelper {
    
    var keychain: Keychain {
        return Keychain(service: Constants.KeychainAccessServices.apiToken)
    }
    
    func getUserToken() -> String? {
        return keychain[Constants.KeychainAccessKeys.userToken]
    }
    
    func setUserToken(_ token: String) {
        keychain[string: Constants.KeychainAccessKeys.userToken] = token
    }
    
    func resetUserToken() throws {
        try keychain.remove(Constants.KeychainAccessKeys.userToken)
    }
    
}
