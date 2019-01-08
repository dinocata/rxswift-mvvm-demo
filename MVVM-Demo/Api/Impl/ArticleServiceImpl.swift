//
//  ArticleServiceImpl.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/01/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import RxSwift

class ArticleServiceImpl: RepositoryService<Article>, ArticleService {
    
    func getArticles() -> Observable<[Article]> {
        return fetchApiData(.getArticles)
    }
    
}
