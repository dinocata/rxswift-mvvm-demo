//
//  SceneCoordinator.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import UIKit

final class SceneCoordinator: SceneCoordinatorType {
    
    private let window: UIWindow
    
    var sceneCount: Int = 0
    
    var currentViewController: UIViewController!
    
    init(
        // sourcery: inject! = AppDelegate.instance.window!
        window: UIWindow) {
        self.window = window
        self.window.makeKeyAndVisible()
    }
    
    func transition(to scene: Scene, type: SceneTransition, completion: (() -> Void)?) {
        self.transition(to: scene.viewController, type: type, completion: completion)
    }
    
    func transition(to viewController: UIViewController, type: SceneTransition, completion: (() -> Void)?) {
        switch type {
        case .root:
            self.window.rootViewController = viewController
            
        case .push(let animated):
            guard let navigationController = self.currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            
            navigationController.pushViewController(
                viewController: viewController,
                animated: animated,
                completion: completion
            )
            
        case .present(let animated),
             .modal(let animated):
            self.currentViewController.present(viewController, animated: animated, completion: completion)
        }
        
        self.currentViewController = viewController.actualViewController
    }
    
    func pop(animated: Bool, completion: (() -> Void)?) {
        if let navigationController = currentViewController.navigationController,
            navigationController.viewControllers.count > 1 {
            
            navigationController.popViewController(
                animated: animated,
                completion: completion
            )
            
            self.currentViewController = navigationController.viewControllers.last
        } else if let presenter = currentViewController.presentingViewController {
            currentViewController.dismiss(animated: animated, completion: completion)
            self.currentViewController = presenter.actualViewController
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from currentViewController!")
        }
    }
    
    func popToRoot(animated: Bool, completion: (() -> Void)?) {
        if let navigationController = currentViewController.navigationController,
            navigationController.viewControllers.count > 1 {
            navigationController.popToRootViewController(animated: animated, completion: completion)
            self.currentViewController = navigationController.viewControllers.first
        }
    }
    
    func onboardingTransition() {
        transition(to: .startScreen)
    }
}
