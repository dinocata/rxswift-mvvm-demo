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
    private let articleRepository: ArticleRepository
    private let validationHelper: ValidationHelper
    
    /// id of 0 indicates it is a new article to be created
    init(articleId: Int32 = 0,
         articleRepository: ArticleRepository,
         validationHelper: ValidationHelper) {
        self.article = articleRepository.getById(id: articleId)
        self.articleRepository = articleRepository
        self.validationHelper = validationHelper
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
        let confirm: Driver<Void>
        let error: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        setupValidators(input: input)
        
        let titleDriver = article
            .map { $0?.name != nil ? "Edit Article" : "New Article" }
            .asDriver(onErrorJustReturn: "New Article")
        
        let wrapperDriver = article
            .filter { $0 != nil }
            .map { Wrapper(article: $0!) }
            .asDriverOnErrorJustComplete()
        
        let validationEventDriver = input.confirm
            .asObservable()
            .flatMapLatest { [unowned self] in self.validate(input: input) }
            .map { [unowned self] in self.mapValidationResult($0) }
        
        let save = validationEventDriver
            .filter { $0.validationSuccessful() }
            .mapToVoid()
            .flatMapLatest { [unowned self] in self.saveArticle(input: input) }
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let error = validationEventDriver
            .map { $0.getErrorMessage() }
            .filter { $0 != nil }
            .map { $0! }
            .asDriverOnErrorJustComplete()
        
        return Output(title: titleDriver,
                      wrapper: wrapperDriver,
                      confirm: save,
                      error: error)
    }
    
}

extension ArticleDetailsVM {
    
    func setupValidators(input: Input) {
        let idValidator = Validator()
        idValidator.integer = true
        input.id.validator = idValidator
        input.id.label = "ID"
        
        input.name.validator = Validator()
        input.name.label = "Name"
        
        input.description.validator = Validator()
        input.description.label = "Description"
        
        let priceValidator = Validator()
        priceValidator.decimal = true
        input.price.validator = priceValidator
        input.price.label = "Price"
    }
    
    func validate(input: Input) -> Single<ValidationResult> {
        return validationHelper.validateInputs([input.id, input.name, input.description, input.price])
    }
    
    func mapValidationResult(_ result: ValidationResult) -> FormEvent {
        switch result {
        case .success:
            return .validationSuccess
        case .failure(let errorMessage):
            return .failure(errorMessage)
        }
    }
    
    func saveArticle(input: Input) -> Observable<Article> {
        let article = ArticleResponse()
        article.id = Int32(input.id.validator!.intValue!)
        article.name = input.name.validator!.stringValue
        article.articleDescription = input.description.validator?.stringValue
        article.price = Int32(input.price.validator!.floatValue!)
        return articleRepository.saveSingle(article)
    }
}
