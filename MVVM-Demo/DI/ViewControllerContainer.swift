//
//  ViewControllerContainer.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation
import Swinject

/// View Controller dependency injections
class ViewControllerContainer: ChildContainerProtocol {
    
    func build(parentContainer: Container) -> Container {
        let container = Container(parent: parentContainer)
        
        // TODO
        
        return container
    }
    
}
