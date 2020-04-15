//
//  UIViewControllerExt.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var actualViewController: UIViewController {
        if let navigationController = self as? UINavigationController {
            return navigationController.viewControllers.first!
        } else {
            return self
        }
    }
}

extension UINavigationController {
    func pushViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        pushViewController(viewController, animated: animated)
        handleCompletion(animated: animated, completion: completion)
    }
    
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool, completion: (() -> Void)?) {
        setViewControllers(viewControllers, animated: animated)
        handleCompletion(animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool, completion: (() -> Void)?) {
        guard popViewController(animated: animated) != nil else {
            fatalError("can't navigate back from \(self)")
        }
        handleCompletion(animated: animated, completion: completion)
    }
    
    func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        guard popToRootViewController(animated: animated) != nil else {
            fatalError("can't navigate back from \(self)")
        }
        handleCompletion(animated: animated, completion: completion)
    }
    
    func popToViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard popToViewController(viewController, animated: animated) != nil else {
            fatalError("can't navigate back from \(self)")
        }
        handleCompletion(animated: animated, completion: completion)
    }
    
    func handleCompletion(animated: Bool, completion: (() -> Void)?) {
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
