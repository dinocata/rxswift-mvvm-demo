//
//  PostRepositoryImpl.swift
//  Data
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift
import Domain

public class PostRepositoryImpl: PostRepository {
    
    public var service: PostService!
    
    public init() {}
    
    public func getPosts() -> Single<NetworkResult<[Post]>> {
        return service.getPosts()
    }
}
