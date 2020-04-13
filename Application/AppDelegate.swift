//
//  AppDelegate.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import UIKit

// sourcery: injectable, singleton
protocol TestSingleton {
    
}

class TestSingletonImpl: TestSingleton {
    
}

// sourcery: injectable = Watafak
protocol Kita {
    
}

class Watafak: Kita {
    var depend: TestSingleton!
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
}
