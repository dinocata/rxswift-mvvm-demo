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
    init(window: UIWindow)
    
    var currentViewController: UIViewController! { get set }
    
    @discardableResult
    func transition(to scene: Scene) -> Completable
    
    @discardableResult
    func transitionRoot(to scene: Scene) -> Completable
    
    // pop scene from navigation stack or dismiss current modal
    @discardableResult
    func pop(animated: Bool) -> Completable
    
    @discardableResult
    func popToRoot(animated: Bool) -> Completable
    
    @discardableResult
    func popToVC(_ viewController: UIViewController, animated: Bool) -> Completable
    
    static func getOnboardingScene(userDefaults: UserDefaultsHelper) -> Scene
    
}
