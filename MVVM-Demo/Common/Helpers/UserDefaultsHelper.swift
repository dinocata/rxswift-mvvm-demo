//
//  UserDefaults.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

protocol UserDefaultsHelper {
    
    /// Checks whether the User is currently logged in (in the App).
    ///
    /// - Returns: True if user is logged in
    func isUserLoggedIn() -> Bool
    
    /// Checks if initial data is synced (done after login, during synchronization).
    ///
    /// - Returns: True if initial data is synced
    func isUserDataSynced() -> Bool
    
    /// Returns timestamp of last time data was synced in seconds.
    ///
    /// - Returns: Sync timestamp
    func getSyncTime() -> Int
    func setSyncTime(timestamp: Int)
    
    /// Clears all user defaults data related to User. Called on logout.
    func clearUserData()
}

