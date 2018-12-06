//
//  SceneControllers.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit

extension Scene {
    
    /// Returns the View Controller associated with this scene (along with all its dependencies).
    var viewController: UIViewController {
        let controllerContainer = ViewControllerContainer.instance!
        switch self {
        case .login:
            return UINavigationController.init(rootViewController: controllerContainer.resolve(LoginVC.self)!)
            
        case .synchronization:
            return controllerContainer.resolve(SynchronizationVC.self)!
            
        case .dashboard:
            return UINavigationController.init(rootViewController: controllerContainer.resolve(DashboardVC.self)!)
            
        case .articleList:
            return UIViewController()
            
        case .articleDetails:
            return UIViewController()
        }
    }
    
    /// Returns the controller transition type associated with this scene.
    var defaultTransition: SceneTransition {
        switch self {
        case .login,
             .dashboard:
            return .present(animated: true)
        default:
            return .push(animated: true)
        }
    }
    
}
