//
//  FloatExtension.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 04/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

extension Float {
    
    func getFormatedString(precision: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = precision
        formatter.maximumFractionDigits = precision
        return formatter.string(from: self as NSNumber)!
    }
}
