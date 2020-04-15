//
//  DashboardViewDataMapper.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Domain

// sourcery: injectable
protocol DashboardViewDataMapper {
    func mapPostData(from resource: Post) -> PostListItemCell.Data
    func mapPostError(from error: NetworkError) -> String
}

final class DashboardViewDataMapperImpl: DashboardViewDataMapper {
    
    func mapPostData(from resource: Post) -> PostListItemCell.Data {
        return .init(
            id: resource.id,
            title: resource.title,
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
            return "Could not fetch posts."
        }
    }
}
