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
    
    static var instance: Container!
    
    /// Helper dependency injections
    private static func registerHelpers() {
        // Keychain Access
        instance.register(KeychainAccessHelper.self) { _ in
            KeychainAccessHelperImpl()
        }
        
        // User Defaults
        instance.register(UserDefaultsHelper.self) {
            UserDefaultsHelperImpl(keychainAccess: $0.resolve(KeychainAccessHelper.self)!)
        }
        
        // Scene Coordinator
        instance.register(SceneCoordinatorType.self) {
            SceneCoordinator(window: AppDelegate.getInstance().window!,
                             userDefaults: $0.resolve(UserDefaultsHelper.self)!)
        }
        
        // Core Data Stack
        instance.register(CoreDataStack.self) { _ in
            CoreDataStackImpl()
        }
        
        // Core Data Helper
        instance.register(CoreDataHelper.self) {
            CoreDataHelperImpl(coreDataStack: $0.resolve(CoreDataStack.self)!)
        }
        
        // Moya Provider
        instance.register(MoyaProvider<ApiService>.self) {
            let keychainAccess = $0.resolve(KeychainAccessHelper.self)
            let authPlugin = AccessTokenPlugin(tokenClosure: { keychainAccess?.getUserToken() ?? "" })
            return MoyaProvider<ApiService>(plugins: [authPlugin])
        }
        
        // Network
        instance.register(NetworkProtocol.self) {
            ApiNetwork(provider: $0.resolve(MoyaProvider<ApiService>.self)!)
        }
        
        // Validation Helper
        instance.register(ValidationHelper.self) { _ in
            ValidationHelperImpl()
        }
        
    }
    
    /// Repository dependency injections
    private static func registerRepositories() {
        instance.register(ArticleRepository.self) {
            ArticleRepositoryImpl(coreDataHelper: $0.resolve(CoreDataHelper.self)!)
        }
    }
    
    /// Service dependency injections
    private static func registerServices() {
        // User service
        instance.register(UserService.self) {
            UserServiceImpl(keychainAccess: $0.resolve(KeychainAccessHelper.self)!,
                            network: $0.resolve(NetworkProtocol.self)!)
        }
        
        // Article service
        instance.register(ArticleService.self) {
            ArticleServiceImpl(repository: $0.resolve(ArticleRepository.self)! as! BaseRepositoryImpl<Article>,
                               network: $0.resolve(NetworkProtocol.self)!)
        }
    }
    
    static func build() -> Container {
        // Automatically defines all registered dependencies as singletons
        instance = Container(defaultObjectScope: .container)
        registerHelpers()
        registerRepositories()
        registerServices()
        return instance
    }
    
}
