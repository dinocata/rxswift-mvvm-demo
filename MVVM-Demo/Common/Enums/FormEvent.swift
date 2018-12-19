//
//  FormEvent.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 18/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

enum FormEvent {
    case validationSuccess
    case success
    case failure(String)
    case loading
    
    static func unknownError() -> FormEvent {
        return .failure("Unknown error")
    }
    
    func validationSuccessful() -> Bool {
        if case .validationSuccess = self {
            return true
        }
        return false
    }
    
    func isSuccessful() -> Bool {
        if case .success = self {
            return true
        }
        return false
    }
    
    func getErrorMessage() -> String? {
        if case .failure(let errorMessage) = self {
            return errorMessage
        }
        return nil
    }
    
    func isLoading() -> Bool {
        if case .loading = self {
            return true
        }
        return false
    }
}
