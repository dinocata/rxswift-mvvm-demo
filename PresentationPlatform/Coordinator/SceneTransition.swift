//
//  SceneTransition.swift
//  PresentationPlatform
//
//  Created by Dino Catalinac on 14/12/2019.
//  Copyright © 2019 DinoCata. All rights reserved.
//

import Foundation

public enum SceneTransition {
    case root(animated: Bool)
    case push(animated: Bool)
    case present(animated: Bool)
    case modal(animated: Bool)
}
