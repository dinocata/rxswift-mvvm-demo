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
    
    func build(parentContainer: Container) -> Container {
        let container = Container(parent: parentContainer)
        
        container.register(LoginVC.self) { r in
            let controller = self.initCoordinatorVC(LoginVC.self, resolver: r)
            controller.viewModel = r.resolve(LoginVM.self)!
            return controller
        }
        
        container.register(SynchronizationVC.self) { r in
            let controller = self.initCoordinatorVC(SynchronizationVC.self, resolver: r)
            // TODO
            return controller
        }
        
        return container
    }
    
    /// Instantiates a CoordinatorVC type injected with a coordinator instance
    /// Call this for every controller which has routing (able to transition to another controller).
    ///
    /// - Parameters:
    ///   - type: View Controller type to instantiate
    ///   - resolver: Container resolver
    private func initCoordinatorVC<T: CoordinatorVC>(_ type: T.Type, resolver: Resolver) -> T {
        let controller = T()
        controller.coordinator = resolver.resolve(SceneCoordinatorType.self)!
        return controller
    }
    
}
