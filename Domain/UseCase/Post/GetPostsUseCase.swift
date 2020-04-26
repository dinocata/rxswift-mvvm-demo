//
//  GetPostsUseCase.swift
//  Domain
//
//  Created by Dino Catalinac on 15/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift

// sourcery: injectable, AutoMockable
public protocol GetPostsUseCase {
    func execute() -> Single<NetworkResult<[Post]>>
}

public class GetPostsUseCaseImpl: GetPostsUseCase {
    
    private let postRepository: PostRepository
    
    public init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    public func execute() -> Single<NetworkResult<[Post]>> {
        return postRepository.getPosts()
    }
}
