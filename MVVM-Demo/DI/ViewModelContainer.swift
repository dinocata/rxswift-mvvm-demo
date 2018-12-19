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
        instance = Container(parent: parentContainer, defaultObjectScope: .transient)
        
        instance.register(LoginVM.self) { r in
            LoginVM(userService: r.resolve(UserService.self)!,
                    validationHelper: r.resolve(ValidationHelper.self)!)
        }
        
        instance.register(DashboardVM.self) { r in
            DashboardVM(userDefaults: r.resolve(UserDefaultsHelper.self)!,
                        coreDataHelper: r.resolve(CoreDataHelper.self)!)
        }
        
        instance.register(SynchronizationVM.self) { r in
            SynchronizationVM()
        }
        
        instance.register(ArticleListVM.self) { r in
            ArticleListVM(articleRepository: r.resolve(ArticleRepository.self)!)
        }
        
        instance.register(ArticleDetailsVM.self) { r, articleId in
            ArticleDetailsVM(articleId: articleId,
                             articleRepository: r.resolve(ArticleRepository.self)!,
                             validationHelper: r.resolve(ValidationHelper.self)!)
        }
        
        return instance
    }
    
}
