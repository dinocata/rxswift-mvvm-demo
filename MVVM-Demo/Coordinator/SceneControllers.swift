//
//  SceneControllers.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit

extension Scene {
    
    /// Returns the View Controller associated with this scene (along with all its dependencies)
    var viewController: UIViewController {
        let appDelegate = AppDelegate.getInstance()
        let controllerContainer = appDelegate.viewControllerContainer!
        switch self {
        case .login:
            let controller = controllerContainer.resolve(LoginVC.self)!
            return UINavigationController.init(rootViewController: controller)
            
        case .synchronization:
            return UIViewController()
            
        case .dashboard:
            return UIViewController()
            
        case .articleList:
            return UIViewController()
            
        case .articleDetails:
            return UIViewController()
        }
    }
    
    /// Returns the controller transition type associated with this scene
    var transition: SceneTransition {
        switch self {
        case .login,
             .dashboard:
            return .root
        default:
            return .push(animated: true)
        }
    }
    
}
