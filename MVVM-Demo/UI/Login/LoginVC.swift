//
//  LoginVC.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: CoordinatorVC, BindableType {
    
    // Outlets
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnConfirm: UIButton!
 
    var viewModel: LoginVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }
    
    func generateInputs() -> LoginVM.Input {
        return LoginVM.Input(emailText: tfEmail.rx.text.orEmpty.asDriver(),
                             passwordText: tfPassword.rx.text.orEmpty.asDriver(),
                             confirm: btnConfirm.rx.tap.asDriver())
    }
    
    func onGenerateOutputs(outputs: LoginVM.Output) {
        outputs.success
            .drive(onNext: { [unowned self] _ in
                self.coordinator.transition(to: .synchronization)
            })
            .disposed(by: disposeBag)
    }

}
