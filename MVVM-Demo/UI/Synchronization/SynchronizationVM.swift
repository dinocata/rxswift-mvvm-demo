//
//  SynchronizationVM.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift
import RxCocoa

class SynchronizationVM {
    
    private let articleService: ArticleService
    
    init(articleService: ArticleService) {
        self.articleService = articleService
    }
}

extension SynchronizationVM: ViewModelType {
    
    struct Input {
        let data = PublishSubject<Void>()
    }
    
    struct Output {
        let data: Driver<[Article]>
    }
    
    func transform(input: Input) -> Output {
        let dataEventDriver = input.data
            .asObserver()
            .flatMapLatest { [unowned self] in self.articleService.getArticles() }
        
        return Output(data: dataEventDriver.asDriverOnErrorJustComplete())
    }
    
}
