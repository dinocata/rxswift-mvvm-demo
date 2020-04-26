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
    
    private let service: PostService
    
    public init(service: PostService) {
        self.service = service
    }
    
    public func getPosts() -> Single<NetworkResult<[Post]>> {
        return service.getPosts()
    }
    
    public func getPost(id: Int) -> Single<NetworkResult<Post>> {
        return service.getPost(id: id)
    }
}
