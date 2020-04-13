//
//  SceneTransition.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Foundation

enum SceneTransition {
    case root(animated: Bool)
    case push(animated: Bool)
    case present(animated: Bool)
    case modal(animated: Bool)
}
