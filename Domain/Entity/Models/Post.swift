//
//  Post.swift
//  Domain
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Foundation

public struct Post: Codable {
    public let id: Int
    public let userId: Int
    public let title: String
    public let body: String
}
