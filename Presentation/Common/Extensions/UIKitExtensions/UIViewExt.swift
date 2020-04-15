//
//  UIViewExt.swift
//  Application
//
//  Created by Dino Catalinac on 14/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import UIKit

extension UIView: NibLoadable {}

extension UIView {
    
    var enabled: Bool {
        get {
            self.isUserInteractionEnabled
        }
        
        set {
            self.isUserInteractionEnabled = newValue
            self.alpha = newValue ? 1.0 : 0.6
        }
    }
}
