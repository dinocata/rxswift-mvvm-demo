//
//  ArticleService.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/01/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import RxSwift

protocol ArticleService {
    func getArticles() -> Observable<[Article]>
}
