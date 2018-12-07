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
        
        registerVC(LoginVC.self)
        registerVC(SynchronizationVC.self)
        registerVC(DashboardVC.self)
        registerVC(ArticleListVC.self)
        
        return instance
    }
    
    /// Registers a Controller to this container.
    /// Use this wrapper method if the controller does not take any extra arguments (reduces boiler plate).
    ///
    /// - Parameter type: Controller type
    private static func registerVC<H: ViewModelType, T: BaseVC<H>>(_ type: T.Type) {
        instance.register(type) { resolver in
            return initVC(type, resolver: resolver)
        }
    }
    
    /// Instantiates a Controller injected with its view model and coordinator instance.
    ///
    /// - Parameters:
    ///   - type: View Controller type to instantiate
    ///   - resolver: Container resolver
    private static func initVC<H: ViewModelType, T: BaseVC<H>>(_ type: T.Type, resolver: Resolver) -> T {
        return T.init(viewModel: resolver.resolve(H.self)!,
                      coordinator: resolver.resolve(SceneCoordinatorType.self)!)
    }
    
}
