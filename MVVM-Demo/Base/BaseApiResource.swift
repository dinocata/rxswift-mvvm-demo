//
//  BaseApiResource.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

protocol BaseApiResource: Codable {
    var id: Int32 { get set }
}
