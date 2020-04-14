//
//  LoginViewDataMapper.swift
//  Application
//
//  Created by Dino Catalinac on 14/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Domain

// sourcery: injectable
protocol LoginViewDataMapper {
    func mapLoginError(from error: NetworkError) -> String
}

class LoginViewDataMapperImpl: LoginViewDataMapper {
    
    func mapLoginError(from error: NetworkError) -> String {
        switch error {
        case .unauthorized,
             .badRequest:
            return "Wrong credentials"
            
        default:
            return "An error occurred"
        }
    }
}
