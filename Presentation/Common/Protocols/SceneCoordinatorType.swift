//
//  SceneCoordinatorType.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import UIKit

protocol SceneCoordinatorType {
    /// Keeps track of currently active view controllers. Helpful for preventing controller leaking.
    /// For a reference, this should always be equal to 1 whenever you navigate back to the Start screen,
    /// which is considered to be the starting point in your app.
    var sceneCount: Int { get set }
    
    /// Current visible view controller.
    var currentViewController: UIViewController! { get set }
    
    init(window: UIWindow)
    
    /// Navigates to a Scene using specified transition type.
    func transition(to scene: Scene, type: SceneTransition, completion: (() -> Void)?)
    
    /// Dismisses (or pops) current view controller.
    func pop(animated: Bool, completion: (() -> Void)?)

    /// Pops the current navigation controller to its root controller.
    func popToRoot(animated: Bool, completion: (() -> Void)?)
    
    /// Called on App start in order to navigate based on current App state.
    func onboardingTransition()
}

// Default implementation
extension SceneCoordinatorType {
    
    /// Navigates to a Scene using the default Scene's transition.
    func transition(to scene: Scene) {
        transition(to: scene, type: scene.defaultTransition(animated: true), completion: nil)
    }
}
