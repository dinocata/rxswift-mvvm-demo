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
        let id: Int32
        let name: String?
        let description: String?
        let price: String?
        
        init(article: Article) {
            self.id = article.id
            self.name = article.name
            self.description = article.articleDescription
            self.price = article.price?.stringValue
        }
    }
    
    struct Input {
        let load = PublishSubject<Void>()
        let generateEvent: Driver<Void>
        let saveEvent: Driver<Void>
    }
    
    struct Output {
        let data: Driver<[TableItem]>
        let generateResult: Driver<Void>
        let saveResult: Driver<Void>
    }
    
    func transform(input: ArticleListVM.Input) -> ArticleListVM.Output {
        let loadEventDriver = input.load
            .asObservable()
            .flatMapLatest { [unowned self] in self.articleRepository.getAll() }
            .map { $0.map { TableItem(article: $0) } }
            .asDriver(onErrorJustReturn: [])
        
        let generateResult = input.generateEvent
            .asObservable()
            .flatMapLatest { [unowned self] in self.generateRandomArticle() }
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let saveResult = input.saveEvent
            .asObservable()
            .do(onNext: { [unowned self] in self.articleRepository.saveRepository() })
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return Output(data: loadEventDriver, generateResult: generateResult, saveResult: saveResult)
    }
    
    private func generateRandomArticle() -> Observable<Article> {
        let articleData = ArticleResponse()
        articleData.id = 338 //Int32.random(in: 0..<1000)
        articleData.name = String.randomString(length: 5)
        articleData.articleDescription = String.randomString(length: 10)
        articleData.price = Int32.random(in: 0..<100)
        return articleRepository.saveSingle(articleData)
    }
    
}
