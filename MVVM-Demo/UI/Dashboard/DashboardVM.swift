//
//  DashboardVM.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 06/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift
import RxCocoa

class DashboardVM: ViewModelType {
    
    private let userDefaults: UserDefaultsHelper
    
    init(userDefaults: UserDefaultsHelper) {
        self.userDefaults = userDefaults
    }
    
    struct Input {
        let articles: Driver<Void>
        let logout: Driver<Void>
    }
    
    struct Output {
        let articles: Driver<Void>
        let logout: Driver<Void>
    }
    
    func transform(input: DashboardVM.Input) -> DashboardVM.Output {
        let logoutEventDriver = input.logout
            .map { [unowned self] in self.userDefaults.clearUserData() }
        
        return Output(articles: input.articles.asDriver(onErrorJustReturn: ()),
                      logout: logoutEventDriver.asDriver(onErrorJustReturn: ()))
    }
    
}
