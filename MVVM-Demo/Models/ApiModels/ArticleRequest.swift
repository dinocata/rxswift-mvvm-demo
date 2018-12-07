//
//  ArticleRequest.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

struct ArticleResponse: Decodable {
    let id: Int32
    let name: String
    let price: Int32?
    let description: String?
}
