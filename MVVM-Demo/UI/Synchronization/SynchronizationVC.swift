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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.coordinator.transition(to: .dashboard)
        }
    }
    
    func generateInputs() -> SynchronizationVM.Input {
        return SynchronizationVM.Input()
    }
    
    func onGenerateOutputs(outputs: SynchronizationVM.Output) {
        // TODO
    }
    
}
