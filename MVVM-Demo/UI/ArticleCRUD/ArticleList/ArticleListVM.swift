//
//  ArticleListVM.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift
import RxCocoa

class ArticleListVM {
    
    private let articleRepository: ArticleRepository
    
    init(articleRepository: ArticleRepository) {
        self.articleRepository = articleRepository
    }
    
}

extension ArticleListVM: ViewModelType {
    
    struct Input {
        let data = PublishSubject<Void>()
        let selection: Driver<IndexPath>
    }
    
    struct Output {
        let data: Driver<[ArticleListItemVM]>
        let details: Driver<Int32>
    }
    
    func transform(input: ArticleListVM.Input) -> ArticleListVM.Output {
        let loadEventDriver = input.data
            .asObservable()
            .flatMapLatest { [unowned self] in self.articleRepository.getAll() }
            .map { $0.map { ArticleListItemVM(article: $0) } }
            .asDriver(onErrorJustReturn: [])
        
        let selectionEventDriver = input.selection
            .withLatestFrom(loadEventDriver) { $1[$0.row].id }
            .asDriver(onErrorJustReturn: 0)
        
        return Output(data: loadEventDriver, details: selectionEventDriver)
    }
    
}
