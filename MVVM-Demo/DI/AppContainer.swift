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
        
        // Core Data Stack
        container.register(CoreDataStack.self) { _ in
            CoreDataStackImpl()
        }
        
        // Core Data Helper
        container.register(CoreDataHelper.self) { r in
            CoreDataHelperImpl(coreDataStack: r.resolve(CoreDataStack.self)!)
        }
        
        // Moya Provider
        container.register(MoyaProvider<ApiService>.self) { r in
            let keychainAccess = r.resolve(KeychainAccessHelper.self)
            let authPlugin = AccessTokenPlugin(tokenClosure: { keychainAccess?.getUserToken() ?? "" })
            return MoyaProvider<ApiService>(plugins: [authPlugin])
        }
        
        container.register(NetworkProtocol.self) { r in
            ApiNetwork(provider: r.resolve(MoyaProvider<ApiService>.self)!)
        }
        
    }
    
    /// Repository dependency injections
    private func registerRepositories(on container: Container) {
        // TODO
    }
    
    /// Service dependency injections
    private func registerServices(on container: Container) {
        container.register(UserService.self) { r in
            UserServiceImpl(keychainAccess: r.resolve(KeychainAccessHelper.self)!,
                            network: r.resolve(NetworkProtocol.self)!)
        }
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
