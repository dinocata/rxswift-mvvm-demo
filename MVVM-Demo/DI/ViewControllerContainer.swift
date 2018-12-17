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
        registerItemVC(ArticleDetailsVC.self)
        
        return instance
    }
    
    /// Registers a Controller to this container.
    /// Use this wrapper method if the controller does not take any extra arguments (reduces boiler plate).
    ///
    /// - Parameter type: Controller type
    private static func registerVC<H: ViewModelType, T: BaseVC<H>>(_ type: T.Type) {
        instance.register(type) { resolver in
            return T.init(viewModel: resolver.resolve(H.self)!,
                          coordinator: resolver.resolve(SceneCoordinatorType.self)!)
        }
    }
    
    /// Registers a Controller that accepts an extra id parameter of a resource the controller is presented for.
    /// E.g. for Details view of a CRUD item.
    ///
    /// - Parameters:
    ///   - type: View Controller type to instantiate
    private static func registerItemVC<H: ViewModelType, T: BaseVC<H>>(_ type: T.Type) {
        instance.register(type) { (resolver, itemId: Int32) in
            return T.init(viewModel: resolver.resolve(H.self, argument: itemId)!,
                          coordinator: resolver.resolve(SceneCoordinatorType.self)!)
        }
    }
}
