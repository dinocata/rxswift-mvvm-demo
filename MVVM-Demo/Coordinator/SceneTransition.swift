//
//  SceneTransition.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

enum SceneTransition {
    case root
    case push(animated: Bool)
    case present(animated: Bool)
    case pushToScene(stackPath: [Scene], animated: Bool)
    case presentSceneNavigation(sceneStack: [Scene], animated: Bool)
}
