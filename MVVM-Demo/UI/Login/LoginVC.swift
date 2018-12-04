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
        let emailVM = TextFieldVM()
        tfEmail.rx.text.orEmpty
            .bind(to: emailVM.value)
            .disposed(by: disposeBag)
        
        let passwordVM = TextFieldVM()
        tfPassword.rx.text.orEmpty
            .bind(to: passwordVM.value)
            .disposed(by: disposeBag)
        
        let inputs = LoginVM.Input(emailInput: emailVM,
                                   passwordInput: passwordVM)
        
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
