//
//  ViewControllerContainer.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation
import Swinject

/// View Controller dependency injections
class ViewControllerContainer: ChildContainerProtocol {
    
    static var instance: Container!
    
    @discardableResult
    static func build(parentContainer: Container) -> Container {
        instance = Container(parent: parentContainer)
        
        instance.register(LoginVC.self) { r in
            return initVC(LoginVC.self, resolver: r)
        }
        
        instance.register(SynchronizationVC.self) { r in
            return initCoordinatorVC(SynchronizationVC.self, resolver: r)
        }
        
        instance.register(DashboardVC.self) { r in
            return initVC(DashboardVC.self, resolver: r)
        }
        
        return instance
    }
    
    /// Instantiates a controller with view model and coordinator injected to it.
    ///
    /// - Parameters:
    ///   - type: View Controller type to instantiate
    ///   - resolver: Container resolver
    private static func initVC<H: ViewModelType, T: BaseVC<H>>(_ type: T.Type, resolver: Resolver) -> T {
        return T.init(viewModel: resolver.resolve(H.self)!,
                      coordinator: resolver.resolve(SceneCoordinatorType.self)!)
    }
    
    /// Instantiates a CoordinatorVC type injected with a coordinator instance.
    /// Call this for every controller which has routing (able to transition to another controller).
    ///
    /// - Parameters:
    ///   - type: View Controller type to instantiate
    ///   - resolver: Container resolver
    private static func initCoordinatorVC<T: CoordinatorVC>(_ type: T.Type, resolver: Resolver) -> T {
        return T.init(coordinator: resolver.resolve(SceneCoordinatorType.self)!)
    }
    
}
