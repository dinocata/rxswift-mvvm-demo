//
//  PostService.swift
//  Data
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift
import Domain

// sourcery: injectable, singleton
public protocol PostService {
    func getPosts() -> Single<NetworkResult<[Post]>>
    func getPost(id: Int) -> Single<NetworkResult<Post>>
}
