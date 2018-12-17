//
//  ArticleRequest.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

class ArticleResponse: BaseApiResource {
    var id: Int32 = 0
    var name: String = ""
    var price: Int32?
    var articleDescription: String?
}
