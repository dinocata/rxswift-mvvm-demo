//
//  PostDetailsViewDataMapper.swift
//  Application
//
//  Created by Dino Catalinac on 14/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Domain

// sourcery: injectable
protocol PostDetailsViewDataMapper {
    func mapPostData(from resource: Post) -> PostDetailsViewController.Data
    func mapPostError(from error: NetworkError) -> String
}

class PostDetailsViewDataMapperImpl: PostDetailsViewDataMapper {
    
    func mapPostData(from resource: Post) -> PostDetailsViewController.Data {
        return .init(
            title: resource.title,
            body: resource.body,
            author: "By: Author \(resource.userId)"
        )
    }
    
    func mapPostError(from error: NetworkError) -> String {
        switch error {
        case .unauthorized:
            return "Unauthorized"
            
        case .internalServerError:
            return "Server error"
            
        case .unrecognized:
            return "An error occurred. Please check your Internet connection."
            
        default:
            return "Could not fetch Post."
        }
    }
}
