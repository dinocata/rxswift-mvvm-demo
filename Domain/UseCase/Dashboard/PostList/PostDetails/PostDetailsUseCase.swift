//
//  PostDetailsUseCase.swift
//  Domain
//
//  Created by Dino Catalinac on 14/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift

// sourcery: injectable
public protocol PostDetailsUseCase {
    func getPost(id: Int) -> Single<NetworkResult<Post>>
}

public class PostDetailsUseCaseImpl: PostDetailsUseCase {
    
    public var postRepository: PostRepository!
    
    public init() {}
    
    public func getPost(id: Int) -> Single<NetworkResult<Post>> {
        return postRepository.getPost(id: id)
    }
}
