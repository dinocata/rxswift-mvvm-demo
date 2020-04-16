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
    
    public var postRepository: PostRepository!
    
    public init() {}
    
    public func execute() -> Single<NetworkResult<[Post]>> {
        return postRepository.getPosts()
    }
}
