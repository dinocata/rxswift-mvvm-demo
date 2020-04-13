//
//  ManualRegistration.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Swinject
import Moya
import Data
import Domain

/// Specific instances which could not be automatically registered via Sourcery
final class ManualRegistration {
    
    private init() {}
    
    static func build(appDelegate: AppDelegate) {
        
        let container = AppContainer.instance
        container.register(SceneCoordinatorType.self) { _ in
            SceneCoordinator(window: appDelegate.window!)
        }
    }
}
