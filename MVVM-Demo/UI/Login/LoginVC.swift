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

class LoginVC: BaseVC<LoginVM>, BindableType {
    
    // Outlets
    @IBOutlet weak var tfEmail: BaseTextField!
    @IBOutlet weak var tfPassword: BaseTextField!
    @IBOutlet weak var btnConfirm: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        bindViewModel()
    }
    
    func generateInputs() -> LoginVM.Input {
        tfEmail.bindViewModel(TextFieldVM())
        tfPassword.bindViewModel(TextFieldVM())
        
        let inputs = LoginVM.Input(emailInput: tfEmail.fieldModel!,
                                   passwordInput: tfPassword.fieldModel!)
        
        btnConfirm.rx.tap
            .bind(to: inputs.confirm)
            .disposed(by: disposeBag)
        
        return inputs
    }
    
    func onGenerateOutputs(outputs: LoginVM.Output) {
        outputs.loading
            .drive(onNext: { [unowned self] in
                self.showProgress()
            })
            .disposed(by: disposeBag)
        
        outputs.failure
            .drive(onNext: { [unowned self] errorMessage in
                self.hideProgress()
                self.showAlert(title: "Login Failed", message: errorMessage)
            })
            .disposed(by: disposeBag)
        
        outputs.success
            .drive(onNext: { [unowned self] _ in
                self.hideProgress()
                self.coordinator.transition(to: .synchronization)
            })
            .disposed(by: disposeBag)
    }
    
}
