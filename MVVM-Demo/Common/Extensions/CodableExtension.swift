//
//  CodableExtension.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 17/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

extension Encodable {
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let convertedString = String(data: data, encoding: .utf8) // the data will be converted to the string
        print(convertedString!)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
}
