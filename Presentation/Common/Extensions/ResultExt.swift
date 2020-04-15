//
//  ResultExt.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Foundation

extension Result {
    
    var value: Success? {
        switch self {
        case .success(let data):
            return data
            
        default:
            return nil
        }
    }
    
    var error: Failure? {
        switch self {
        case .failure(let error):
            return error
            
        default:
            return nil
        }
    }
}
