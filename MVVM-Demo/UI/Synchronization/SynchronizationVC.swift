//
//  SynchronizationVC.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 03/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit

class SynchronizationVC: BaseVC<SynchronizationVM>, BindableType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Synchronization"
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
            self.coordinator.transition(to: .dashboard)
        }
    }
    
    func createInput() -> SynchronizationVM.Input {
        return SynchronizationVM.Input()
    }
    
    func onCreateOutput(output: SynchronizationVM.Output) {
        // TODO
    }
    
}
