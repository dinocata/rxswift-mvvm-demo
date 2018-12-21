//
//  ArticleRepository.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 21/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift

protocol ArticleRepository: class {
    func getById(id: Int32) -> Observable<Article?>
    func getAll() -> Observable<[Article]>
    func saveSingle(_ apiResponseData: Article.DataType) -> Observable<Article>
    func saveList(_ apiResponseData: [Article.DataType]) -> Observable<[Article]>
    func saveRepository()
    
    func someArticleSpecificFunction()
}
