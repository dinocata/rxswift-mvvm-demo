//
//  SceneCoordinator.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SceneCoordinator: SceneCoordinatorType {
    
    private var window: UIWindow
    private let userDefaults: UserDefaultsHelper
    
    var currentViewController: UIViewController! {
        didSet {
            if !(currentViewController is CoordinatorVC) {
                fatalError("Controller must be an instance of CoordinatorVC")
            }
        }
    }
    
    required init(window: UIWindow, userDefaults: UserDefaultsHelper) {
        self.window = window
        self.userDefaults = userDefaults
    }
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransition) -> Completable {
        let subject = PublishSubject<Void>()
        let viewController = scene.viewController
        
        switch type {
        case .root:
            window.rootViewController = viewController
            subject.onCompleted()
            
        case .push(let animated):
            guard let navigationController = currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            
            navigationController.pushViewController(viewController: viewController, animated: animated) {
                subject.onCompleted()
            }
            
        case .present(let animated):
            currentViewController.present(viewController, animated: animated) {
                subject.onCompleted()
            }
            
        case .pushToScene(let stack, let animated):
            guard let navigationController = currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            
            var controllers = navigationController.viewControllers
            stack.forEach { controllers.append($0.viewController) }
            controllers.append(viewController)
            
            navigationController.setViewControllers(controllers, animated: animated) {
                subject.onCompleted()
            }
            
        case .presentSceneNavigation(let stack, let animated):
            guard let navigationController = viewController as? UINavigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            
            var controllers = navigationController.viewControllers
            stack.forEach { controllers.append($0.viewController) }
            navigationController.setViewControllers(controllers, animated: false)

            if window.rootViewController != nil {
                currentViewController.present(navigationController, animated: animated) {
                    subject.onCompleted()
                }
            } else {
                window.rootViewController = navigationController
                subject.onCompleted()
            }
        }
        
        currentViewController = viewController.actualViewController()
        
        return subject.ignoreElements()
    }
    
    @discardableResult
    func pop(animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        
        if let presenter = currentViewController.presentingViewController {
            // dismiss a modal controller
            currentViewController.dismiss(animated: animated) {
                subject.onCompleted()
            }
            self.currentViewController = presenter.actualViewController()
        } else if let navigationController = currentViewController.navigationController {
            // navigate up the stack
            navigationController.popViewController(animated: animated) {
                subject.onCompleted()
            }
            self.currentViewController = navigationController.viewControllers.last!
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController!)")
        }
        return subject.ignoreElements()
    }
    
    @discardableResult
    func popToRoot(animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        
        if let navigationController = currentViewController.navigationController {
            // navigate up the stack
            navigationController.popToRootViewController(animated: animated) {
                subject.onCompleted()
            }
            self.currentViewController = navigationController.viewControllers.first!
        }
        
        return subject.ignoreElements()
    }
    
    @discardableResult
    func popToVC(_ viewController: UIViewController, animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        
        if let navigationController = currentViewController.navigationController {
            // navigate up the stack
            navigationController.popToViewController(viewController: viewController, animated: animated) {
                subject.onCompleted()
            }
            self.currentViewController = navigationController.viewControllers.last!
        }
        return subject.ignoreElements()
    }
    
    func onboardingTransition() {
        let transitionType: SceneTransition = window.rootViewController != nil
            ? .present(animated: true) : .root
        
        if !userDefaults.isUserLoggedIn() {
            transition(to: .login, type: transitionType)
            return
        }
    
        if !userDefaults.isUserDataSynced() {
            transition(to: .login, type: .presentSceneNavigation(sceneStack: [.synchronization], animated: true))
            return
        }
        
        transition(to: .dashboard, type: transitionType)
    }

}

