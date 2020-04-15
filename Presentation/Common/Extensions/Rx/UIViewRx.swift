//
//  UIViewRx.swift
//  Application
//
//  Created by Dino Catalinac on 14/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UIView {
    
    var enabled: Binder<Bool> {
        return Binder(self.base) { view, enabled in
            view.enabled = enabled
        }
    }
}
