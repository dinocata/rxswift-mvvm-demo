//
//  ArticleServiceImpl.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/01/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import RxSwift

class ArticleServiceImpl: BaseService, ArticleService {
    
    func getArticles() -> Single<[ArticleResponse]> {
        return request(.getArticles, responseType: [ArticleResponse].self)
            .map({
                switch $0 {
                case .success(let data):
                    return data
                default:
                    return []
                }
            })
    }
    
}
