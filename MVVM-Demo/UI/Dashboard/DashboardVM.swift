//
//  DashboardVM.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 06/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift
import RxCocoa

class DashboardVM {
    
    private let userDefaults: UserDefaultsHelper
    private let coreDataHelper: CoreDataHelper
    
    init(userDefaults: UserDefaultsHelper,
         coreDataHelper: CoreDataHelper) {
        self.userDefaults = userDefaults
        self.coreDataHelper = coreDataHelper
    }
    
}

extension DashboardVM: ViewModelType {
    
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
            .do(onNext: { [unowned self] in
                self.userDefaults.clearUserData()
                self.coreDataHelper.deleteAllData()
            })
        
        return Output(articles: input.articles.asDriver(onErrorJustReturn: ()),
                      logout: logoutEventDriver.asDriver(onErrorJustReturn: ()))
    }
    
}
