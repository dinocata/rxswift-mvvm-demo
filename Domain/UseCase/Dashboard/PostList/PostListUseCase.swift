//
//  PostListUseCase.swift
//  Domain
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift

// sourcery: injectable
public protocol PostListUseCase {
    func getPosts() -> Single<NetworkResult<[Post]>>
}

public class PostListUseCaseImpl: PostListUseCase {
    
    public var postRepository: PostRepository!
    
    public init() {}
    
    public func getPosts() -> Single<NetworkResult<[Post]>> {
        postRepository.getPosts()
    }
}
