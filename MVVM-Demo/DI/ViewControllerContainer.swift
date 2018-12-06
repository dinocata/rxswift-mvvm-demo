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
            let controller = initCoordinatorVC(LoginVC.self, resolver: r)
            controller.viewModel = r.resolve(LoginVM.self)!
            return controller
        }
        
        instance.register(SynchronizationVC.self) { r in
            let controller = initCoordinatorVC(SynchronizationVC.self, resolver: r)
            // TODO
            return controller
        }
        
        instance.register(DashboardVC.self) { r in
            let controller = initCoordinatorVC(DashboardVC.self, resolver: r)
            controller.viewModel = r.resolve(DashboardVM.self)!
            return controller
        }
        
        return instance
    }
    
    /// Instantiates a CoordinatorVC type injected with a coordinator instance
    /// Call this for every controller which has routing (able to transition to another controller).
    ///
    /// - Parameters:
    ///   - type: View Controller type to instantiate
    ///   - resolver: Container resolver
    private static func initCoordinatorVC<T: CoordinatorVC>(_ type: T.Type, resolver: Resolver) -> T {
        let controller = T()
        controller.coordinator = resolver.resolve(SceneCoordinatorType.self)!
        return controller
    }
    
}
