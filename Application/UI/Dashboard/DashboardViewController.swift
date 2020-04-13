//
//  DashboardViewController.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import UIKit
import RxCocoa

// sourcery: scene = dashboard
class DashboardViewController: MVVMController<DashboardViewModel> {
    
    // MARK: View definition
    // TODO: Define views here
    
    // MARK: Setup
    override func setupView() {
        self.title = "Dashboard"
        
        self.view.backgroundColor = .lightGray
    }
    
    // MARK: View Model Binding
    override func bindInput() -> DashboardViewModel.Input {
        // TODO: Add implementation
        return DashboardViewModel.Input()
    }
    
    override func bindOutput(_ output: DashboardViewModel.Output) {
        // TODO: Add implementation
    }
}
