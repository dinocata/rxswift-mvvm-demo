//
//  GitHubService.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 03/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Moya

enum ApiService {
    case login(_ requestBody: LoginRequest)
    case getArticles
    case getUsers
}

extension ApiService: TargetType, AccessTokenAuthorizable {
    
    var baseURL: URL { return URL(string: Constants.Api.getBaseUrl())! }
    
    var path: String {
        switch self {
        case .login:
            return "auth/login"
        case .getArticles:
            return "user/registered"
        case .getUsers:
            return "user/all-registered"
        }
    }
    
    var method: Method {
        switch self {
        case .login:
            return .post
        case .getArticles,
             .getUsers:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .login(let requestBody):
            return .requestJSONEncodable(requestBody)
        case .getArticles,
             .getUsers:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var authorizationType: AuthorizationType {
        switch self {
        case .login:
            return .none
        default:
            return .bearer
        }
    }
    
    var sampleData: Data {
        switch self {
        case .login:
            return "login_user_response".localized.utf8Encoded
        case .getArticles:
            return "get_articles_response".localized.utf8Encoded
        default:
            return "test".utf8Encoded
        }
    }
    
}

