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
    
    static var instance: Container!
    
    static func build(parentContainer: Container) -> Container {
        instance = Container(parent: parentContainer)
        
        instance.register(LoginVM.self) { r in
            LoginVM(userService: r.resolve(UserService.self)!,
                    validationHelper: r.resolve(ValidationHelper.self)!)
        }
        
        instance.register(DashboardVM.self) { r in
            DashboardVM(userDefaults: r.resolve(UserDefaultsHelper.self)!)
        }
        
        return instance
    }
    
}
