//
//  Constants.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

final class Constants {
    
    static let appleId = "12345"
    
    class Config {
        static let persistentContainerName = "mvvm_demo"
        // Whether to log network requests and responses in the console. Used for debugging.
        static let networkActivityLogging = true
    }
    
    class Api {
        enum Environment {
            case development
            case testing
            case staging
            case production
        }
        
        static var selectedEnvironment = Environment.development
        
        static func getBaseUrl() -> String {
            switch selectedEnvironment {
            case .development:
                return "http://localhost:3000/"
            case .testing:
                return "TESTING URL"
            case .staging:
                return "STAGING URL"
            case .production:
                return "PRODUCTION URL"
            }
        }
    }
    
    class KeychainAccessServices {
        static let githubToken = "com.example.github-token"
    }
    
    class KeychainAccessKeys {
        static let userToken = "user_token"
    }
    
    class UserDefaultsKeys {
        static let syncTime = "sync_time"
    }

}