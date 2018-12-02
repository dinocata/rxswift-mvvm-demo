//
//  ViewModelContainer.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation
import Swinject

/// View Model dependency injections
class ViewModelContainer: ChildContainerProtocol {
    
    func build(parentContainer: Container) -> Container {
        let container = Container(parent: parentContainer)
        
        container.register(LoginVM.self) { r in
            LoginVM(coordinator: r.resolve(SceneCoordinatorType.self)!)
        }
        
        return container
    }
    
}
