//
//  Reusable.swift
//  Application
//
//  Created by Dino Catalinac on 14/04/2020.
//  Copyright © https://github.com/AliSoftware/Reusable
//

import Foundation

protocol Reusable: class {
    /// The reuse identifier to use when registering and later dequeuing a reusable cell
    static var reuseIdentifier: String { get }
}

extension Reusable {
    /// By default, use the name of the class as String for its reuseIdentifier
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
