//
//  ArticleDetailsVM.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 17/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift
import RxCocoa

class ArticleDetailsVM {
    
    private let article: Observable<Article?>
    
    /// id of 0 indicates it is a new article to be created
    init(articleId: Int32 = 0, articleRepository: ArticleRepository) {
        self.article = articleRepository.getById(id: articleId)
    }
    
    struct Wrapper {
        let id: String
        let name: String?
        let description: String?
        let price: String?
        
        init(article: Article) {
            self.id = "\(article.id)"
            self.name = article.name
            self.description = article.articleDescription
            self.price = article.price?.stringValue
        }
    }
}

extension ArticleDetailsVM: ViewModelType {
    
    struct Input {
        var id: TextFieldVM
        var name: TextFieldVM
        var description: TextFieldVM
        var price: TextFieldVM
        let confirm: Driver<Void>
    }
    
    struct Output {
        let title: Driver<String>
        let wrapper: Driver<Wrapper>
    }
    
    func transform(input: Input) -> Output {
        let titleDriver = article.map { ($0?.name != nil) ? "Edit \($0!.name!)" : "New Article" }
        let wrapperDriver = article
            .filter { $0 != nil }
            .map { Wrapper(article: $0!) }
        
        return Output(title: titleDriver.asDriver(onErrorJustReturn: "New Article"),
                      wrapper: wrapperDriver.asDriverOnErrorJustComplete())
    }
    
}
