//
//  ApiService.swift
//  Data
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Moya

public enum ApiService {
    case login(request: Encodable)
    case posts
}

extension ApiService: TargetType {
    
    public var baseURL: URL {
        return ApiConfig.shared.baseUrl
    }
    
    public var path: String {
        switch self {
        case .login:
            // This path does not actually exist on the Rest API, so we will mock the response
            return "login"
        
        case .posts:
            return "posts"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
            
        case .posts:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .login(let request):
            return .requestJSONEncodable(request)
        
        case .posts:
            return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        return ApiConfig.shared.baseHeaders
    }
    
    public var sampleData: Data {
        switch self {
        case .login:
            return """
            {
                "token": "abc123",
                "userId": 123,
                "email": "test@test.com"
            }
            """.data(using: .utf8)!
            
        default:
            return "".data(using: .utf8)!
        }
      }
}
