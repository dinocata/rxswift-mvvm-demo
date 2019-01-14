//
//  SynchronizationVC.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 03/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit

class SynchronizationVC: BaseVC<SynchronizationVM>, BindableType {
    
    // Outlets
    @IBOutlet weak var btnCancel: UIButton!
    
    // Vars
    private var inputs: SynchronizationVM.Input!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Synchronization"
        
        bindViewModel()
        inputs.data.onNext(())
    }
    
    func createInput() -> SynchronizationVM.Input {
        inputs = SynchronizationVM.Input()
        return inputs
    }
    
    func onCreateOutput(output: SynchronizationVM.Output) {
        output.data
            .drive(onNext: { [weak self] in
                $0.forEach({ print("\($0.name ?? ""), \($0.articleDescription ?? "")") })
                self?.coordinator.transition(to: .dashboard)
            })
            .disposed(by: disposeBag)
    }
    
}
