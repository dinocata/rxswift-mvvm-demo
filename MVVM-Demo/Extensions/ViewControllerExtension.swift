//
//  ViewControllerExtension.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func actualViewController() -> UIViewController {
        if let navigationController = self as? UINavigationController {
            return navigationController.viewControllers.first!
        } else {
            return self
        }
    }
    
    func showAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}

extension UINavigationController {
    func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping () -> ()) {
        pushViewController(viewController, animated: animated)
        
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    
    func popViewController(animated: Bool, completion: (() -> Void)? = nil) {
        guard popViewController(animated: animated) != nil else {
            fatalError("can't navigate back from \(self)")
        }
        
        if let completion = completion {
            if let coordinator = transitionCoordinator, animated {
                coordinator.animate(alongsideTransition: nil) { _ in
                    completion()
                }
            } else {
                completion()
            }
        }
    }
    
    func popToRootViewController(animated: Bool, completion: (() -> Void)? = nil) {
        guard popToRootViewController(animated: animated) != nil else {
            fatalError("can't navigate back from \(self)")
        }
        
        if let completion = completion {
            if let coordinator = transitionCoordinator, animated {
                coordinator.animate(alongsideTransition: nil) { _ in
                    completion()
                }
            } else {
                completion()
            }
        }
    }
    
    func popToViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        guard popToViewController(viewController, animated: animated) != nil else {
            fatalError("can't navigate back from \(self)")
        }
        
        if let completion = completion {
            if let coordinator = transitionCoordinator, animated {
                coordinator.animate(alongsideTransition: nil) { _ in
                    completion()
                }
            } else {
                completion()
            }
        }
    }
}
