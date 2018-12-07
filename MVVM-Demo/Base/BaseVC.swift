//
//  BaseVC.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

class BaseVC<T: ViewModelType>: CoordinatorVC {
    
    var viewModel: T
    
    required init(viewModel: T, coordinator: SceneCoordinatorType) {
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
