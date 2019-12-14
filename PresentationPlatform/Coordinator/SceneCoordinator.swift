//
//  SceneCoordinator.swift
//  PresentationPlatform
//
//  Created by Dino Catalinac on 14/12/2019.
//  Copyright © 2019 DinoCata. All rights reserved.
//

import UIKit

public protocol SceneCoordinatorType {
    /// Current visible view controller.
    var currentViewController: UIViewController! { get set }
    
    /// Navigates to a Scene using specified transition type.
    ///
    /// - Parameters:
    ///   - scene: Scene to navigate to
    ///   - type: Transition type
    func transition(to scene: Scene, type: SceneTransition, completion: (() -> Void)?)
    
    /// Dismisses (or pops) current view controller.
    ///
    /// - Parameter animated: Animated transition
    func pop(animated: Bool, completion: (() -> Void)?)
    
    /// Pops the current navigation controller to its root controller.
    ///
    /// - Parameter animated: Animated transition
    func popToRoot(animated: Bool, completion: (() -> Void)?)
    
    /// Pops the current navigation controller to the specified child controller.
    ///
    /// - Parameters:
    ///   - viewController: View controller to pop to
    ///   - animated: animated: Animated transition
    func popToVC(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    
    /// Call in order to navigate based on current App state.
    func onboardingTransition(animated: Bool, completion: (() -> Void)?)
}

final class SceneCoordinator: SceneCoordinatorType {
    
    private var window: UIWindow
    
    var currentViewController: UIViewController! {
        didSet {
            if let navigationController = currentViewController as? UINavigationController ?? currentViewController.navigationController {
                self.currentNavigationController = navigationController
            }
        }
    }
    
    private weak var currentNavigationController: UINavigationController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    
    func transition(to scene: Scene, type: SceneTransition, completion: (() -> Void)?) {
        let viewController = scene.viewController
        
        switch type {
        case .root(let animated):
            if animated && window.rootViewController != nil {
                var transitionOptions = TransitionOptions()
                let view = UIView()
                view.backgroundColor = appTheme.colors.primaryDark
                transitionOptions.background = .customView(view)
                window.setRootViewController(viewController, options: transitionOptions)
            } else {
                window.rootViewController = viewController
            }
            completion?()
            
        case .push(let animated):
            guard let navigationController = currentNavigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            
            navigationController.pushViewController(viewController: viewController,
                                                    animated: animated,
                                                    completion: completion)
            
        case .present(let animated),
             .modal(let animated):
            currentViewController.present(viewController,
                                          animated: animated,
                                          completion: completion)
        }
        
        currentViewController = viewController.actualViewController()
    }
    
    func pop(animated: Bool, completion: (() -> Void)?) {
        if currentViewController.navigationController != nil,
            let navigationController = currentNavigationController,
            navigationController.viewControllers.count > 1 {
            // navigate up the stack
            navigationController.popViewController(animated: animated, completion: completion)
            self.currentViewController = navigationController.viewControllers.last!
        } else if let presenter = currentViewController.presentingViewController {
            // dismiss a modal controller
            currentViewController.dismiss(animated: animated, completion: completion)
            self.currentViewController = presenter.actualViewController()
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController!)")
        }
    }
    
    func popToRoot(animated: Bool, completion: (() -> Void)?) {
        if let navigationController = currentNavigationController,
            navigationController.viewControllers.count > 1 {
            // navigate up the stack
            navigationController.popToRootViewController(animated: animated, completion: completion)
            self.currentViewController = navigationController.viewControllers.first!
        } else {
            window.rootViewController?.dismiss(animated: animated, completion: completion)
            self.currentViewController = window.rootViewController
        }
    }
    
    func popToVC(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navigationController = currentNavigationController {
            // navigate up the stack
            navigationController.popToViewController(viewController: viewController,
                                                     animated: animated,
                                                     completion: completion)
            self.currentViewController = navigationController.viewControllers.last!
        }
    }
    
    func onboardingTransition(animated: Bool, completion: (() -> Void)?) {
        if !userDefaults.isUserLoggedIn() {
            transition(to: .startScreen, animated: animated)
            return
        }
        
        if userDefaults.syncTime == 0 {
            transition(to: .sync, animated: animated)
            return
        }
        
        transition(to: .dashboard, animated: animated)
    }
}
