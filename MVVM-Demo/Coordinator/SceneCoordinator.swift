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
   
    fileprivate var window: UIWindow
    var currentViewController: UIViewController!
    
    required init(window: UIWindow) {
        self.window = window
    }

    @discardableResult
    func transition(to scene: Scene) -> Completable {
        let subject = PublishSubject<Void>()
        let viewController = scene.viewController
        let type = scene.transition
        
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
            
        case .modal(let animated):
            currentViewController.present(viewController, animated: animated) {
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
                self.currentViewController = presenter.actualViewController()
                subject.onCompleted()
            }
        } else if let navigationController = currentViewController.navigationController {
            // navigate up the stack
            navigationController.popViewController(animated: animated) {
                self.currentViewController = navigationController.viewControllers.last!
                subject.onCompleted()
            }
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
                self.currentViewController = navigationController.viewControllers.first!
                subject.onCompleted()
            }
        }
        
        return subject.ignoreElements()
    }
    
    @discardableResult
    func popToVC(_ viewController: UIViewController, animated: Bool) -> Completable {
        
        let subject = PublishSubject<Void>()
        
        if let navigationController = currentViewController.navigationController {
            // navigate up the stack
            navigationController.popToViewController(viewController: viewController, animated: animated) {
                self.currentViewController = navigationController.viewControllers.last!
                subject.onCompleted()
            }
        }
        return subject.ignoreElements()
    }
    
    static func getOnboardingScene(userDefaults: UserDefaultsHelper) -> Scene {
        if !userDefaults.isUserLoggedIn() {
            return .login
        }
        
        if !userDefaults.isUserDataSynced() {
            return .synchronization
        }
        
        return .dashboard
    }
    
}

