//
//  ContainerProtocol.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation
import Swinject

protocol ContainerProtocol {
    func build() -> Container
}

protocol ChildContainerProtocol {
    func build(parentContainer: Container) -> Container
}
