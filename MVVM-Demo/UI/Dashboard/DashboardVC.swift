//
//  DashboardVC.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 06/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit

class DashboardVC: CoordinatorVC, BindableType {
    
    // Outlets
    @IBOutlet weak var btnLogout: UIButton!
    
    var viewModel: DashboardVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func generateInputs() -> DashboardVM.Input {
        let inputs = DashboardVM.Input()
        
        btnLogout.rx.tap
            .bind(to: inputs.logout)
            .disposed(by: disposeBag)
        
        return inputs
    }
    
    func onGenerateOutputs(outputs: DashboardVM.Output) {
        outputs.logout
            .drive(onNext: { [weak self] in
                _ = self?.coordinator.pop(animated: true)
                    .subscribe(onCompleted: {
                        self?.coordinator.popToRoot(animated: false)
                    })
            })
            .disposed(by: disposeBag)
    }
    
}
