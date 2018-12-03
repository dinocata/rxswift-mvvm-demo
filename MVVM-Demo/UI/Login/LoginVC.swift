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
        return LoginVM.Input(emailInput: InputWrapper(value: tfEmail.rx.text.orEmpty.asDriver()),
                             passwordInput: InputWrapper(value: tfPassword.rx.text.orEmpty.asDriver()),
                             confirm: btnConfirm.rx.tap.asDriver())
    }
    
    func onGenerateOutputs(outputs: LoginVM.Output) {
        outputs.loading
            .drive(onNext: { [unowned self] isLoading in
                if isLoading {
                    self.showProgress()
                } else {
                    self.hideProgress()
                }
            })
            .disposed(by: disposeBag)
        
        outputs.failure
            .drive(onNext: { [unowned self] errorMessage in
                self.showAlert(title: "Login Failed", message: errorMessage)
            })
            .disposed(by: disposeBag)
        
        outputs.success
            .drive(onNext: { [unowned self] _ in
                self.coordinator.transition(to: .synchronization)
            })
            .disposed(by: disposeBag)
    }
    
}
