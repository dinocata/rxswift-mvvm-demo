//
//  GetPostByIdUseCase.swift
//  Domain
//
//  Created by Dino Catalinac on 15/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift

// sourcery: injectable, AutoMockable
public protocol GetPostByIdUseCase {
    func execute(id: Int) -> Single<NetworkResult<Post>>
}

public class GetPostByIdUseCaseImpl: GetPostByIdUseCase {
    
    private let postRepository: PostRepository
    
    public init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    public func execute(id: Int) -> Single<NetworkResult<Post>> {
        return postRepository.getPost(id: id)
    }
}
