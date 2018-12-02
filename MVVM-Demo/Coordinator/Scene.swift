//
//  Scene.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//
// Credits: https://medium.com/smoke-swift-every-day/rxswift-coordinator-pattern-done-right-c8f123fdf2b2
//

import Foundation

enum Scene {
    // Login
    case login
    case synchronization
    
    // Dashboard
    case dashboard
    
    // Article CRUD
    case articleList
    case articleDetails
}
