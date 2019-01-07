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
       
        instance.register(LoginVM.self) {
            LoginVM(userService: $0.resolve(UserService.self)!,
                    validationHelper: $0.resolve(ValidationHelper.self)!)
        }
        
        instance.register(DashboardVM.self) {
            DashboardVM(userDefaults: $0.resolve(UserDefaultsHelper.self)!,
                        coreDataHelper: $0.resolve(CoreDataHelper.self)!)
        }
        
        instance.register(SynchronizationVM.self) {
            SynchronizationVM(articleService: $0.resolve(ArticleService.self)!)
        }
        
        instance.register(ArticleListVM.self) {
            ArticleListVM(articleRepository: $0.resolve(ArticleRepository.self)!)
        }
        
        instance.register(ArticleDetailsVM.self) {
            ArticleDetailsVM(articleId: $1,
                             articleRepository: $0.resolve(ArticleRepository.self)!,
                             validationHelper: $0.resolve(ValidationHelper.self)!)
        }
        
        return instance
    }
    
}
