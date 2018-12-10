//
//  ArticleListVM.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift
import RxCocoa

class ArticleListVM: ViewModelType {
    
    private let articleRepository: ArticleRepository
    
    init(articleRepository: ArticleRepository) {
        self.articleRepository = articleRepository
    }
    
    struct TableItem {
        let name: String
        let description: String
        let price: String?
        
        init(article: Article) {
            self.name = article.name!
            self.description = article.description
            self.price = article.price?.stringValue
        }
    }
    
    struct Input {
        let load = PublishSubject<Void>()
    }
    
    struct Output {
        let data: Driver<[TableItem]>
    }
    
    func transform(input: ArticleListVM.Input) -> ArticleListVM.Output {
        let loadEventDriver = input.load
            .asObservable()
            .flatMapLatest { [unowned self] in self.articleRepository.getAll() }
            .map { $0.map { TableItem(article: $0) } }
            .asDriver(onErrorJustReturn: [])
        
        return Output(data: loadEventDriver)
    }
    
}
