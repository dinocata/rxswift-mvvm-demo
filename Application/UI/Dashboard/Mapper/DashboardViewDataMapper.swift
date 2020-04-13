//
//  DashboardViewDataMapper.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Domain

// sourcery: injectable
final class DashboardViewDataMapper: Mapper {
    
    func map(from resource: Post) -> PostListViewData {
        return .init(
            title: resource.title,
            author: "Author \(resource.userId)"
        )
    }
}
