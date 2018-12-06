//
//  SceneCoordinatorType.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
    init(window: UIWindow, userDefaults: UserDefaultsHelper)
    
    /// Current visible view controller.
    var currentViewController: UIViewController! { get set }
    
    /// Navigates to a Scene using specified transition type.
    ///
    /// - Parameters:
    ///   - scene: Scene to navigate to
    ///   - type: Transition type
    /// - Returns: Completion observable
    @discardableResult
    func transition(to scene: Scene, type: SceneTransition) -> Completable
    
    /// Dismisses (or pops) current view controller.
    ///
    /// - Parameter animated: Animated transition
    /// - Returns: Completion observable
    @discardableResult
    func pop(animated: Bool) -> Completable

    /// Pops the current navigation controller to its root controller.
    ///
    /// - Parameter animated: Animated transition
    /// - Returns: Completion observable
    @discardableResult
    func popToRoot(animated: Bool) -> Completable
    
    /// Pops the current navigation controller to the specified child controller.
    ///
    /// - Parameters:
    ///   - viewController: View controller to pop to
    ///   - animated: animated: Animated transition
    /// - Returns: Completion observable
    @discardableResult
    func popToVC(_ viewController: UIViewController, animated: Bool) -> Completable
    
    /// Called on App start in order to navigate based on current App state.
    /// If you're not sure which controller you should navigate to next, use this method.
    func onboardingTransition()
    
}

extension SceneCoordinatorType {
    
    /// Navigates to a Scene using the default Scene's transition.
    ///
    /// - Parameter scene: Scene to navigate to
    /// - Returns: Completion observable
    @discardableResult
    func transition(to scene: Scene) -> Completable {
        return transition(to: scene, type: scene.defaultTransition)
    }
}
