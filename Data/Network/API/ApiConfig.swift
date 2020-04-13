//
//  ApiConfig.swift
//  Data
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Foundation

// Mock for testing
final class ApiConfig {
    
    static let shared = ApiConfig()
    
    var baseUrl: URL {
        return URL(string: "https://jsonplaceholder.typicode.com/")!
    }
    
    var baseHeaders: [String: String] {
        return [
            "Content-type": "application/json"
        ]
    }
}
