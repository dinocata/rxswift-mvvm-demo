//
//  ArticleListItemVM.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 17/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

struct ArticleListItemVM {
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
