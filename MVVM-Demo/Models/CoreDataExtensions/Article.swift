//
//  Article.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import CoreData

extension Article: Identifiable {
    
    static var defaultSortProperty: String {
        return "id"
    }
    
    typealias DataType = ArticleResponse
    
    func populate(with data: ArticleResponse, coreDataHelper: CoreDataHelper) -> Self {
        id = data.id
        name = data.name
        price = data.price as NSNumber?
        articleDescription = data.description
        return self
    }
    
}
