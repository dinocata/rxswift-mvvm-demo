//
//  KeychainAccessHelper.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation
import KeychainAccess

protocol KeychainAccessHelper {
    var keychain: Keychain { get }
    
    /// Returns Auth token assigned to the User stored in the keychain.
    ///
    /// - Returns: Auth token
    func getUserToken() -> String?
    func setUserToken(_ token: String)
    
    /// Removes Auth token from the keychain. Called on logout.
    ///
    /// - Throws: If token does not exist in the keychain
    func resetUserToken() throws
}

