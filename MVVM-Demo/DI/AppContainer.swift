//
//  AppContainer.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation
import Swinject
import Moya

/// App-wide dependency injections.
/// Defines helper, service and repository singletons.
final class AppContainer: ContainerProtocol {
    
    /// Helper dependency injections
    private func registerHelpers(on container: Container) {
        
        // Keychain Access
        container.register(KeychainAccessHelper.self) { _ in
            KeychainAccessHelperImpl()
        }
        
        // User Defaults
        container.register(UserDefaultsHelper.self) { r in
            UserDefaultsHelperImpl(keychainAccess: r.resolve(KeychainAccessHelper.self)!)
        }
        
        // Scene Coordinator
        container.register(SceneCoordinatorType.self) { _ in
            SceneCoordinator(window: AppDelegate.getInstance().window!)
        }
    }
    
    /// Repository dependency injections
    private func registerRepositories(on container: Container) {
        // TODO
    }
    
    /// Service dependency injections
    private func registerServices(on container: Container) {
        // TODO
    }
    
    func build() -> Container {
        // Automatically defines all registered dependencies as singletons
        let container = Container(defaultObjectScope: .container)
        registerHelpers(on: container)
        registerRepositories(on: container)
        registerServices(on: container)
        return container
    }
    
}
