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
    
    func createInput() -> LoginVM.Input {
        tfEmail.bindViewModel(TextFieldVM())
        tfPassword.bindViewModel(TextFieldVM())
        
        return LoginVM.Input(emailInput: tfEmail.fieldModel!,
                             passwordInput: tfPassword.fieldModel!,
                             confirm: btnConfirm.rx.tap.asDriver())
    }
    
    func onCreateOutput(output: LoginVM.Output) {
        output.loading
            .drive(onNext: { [unowned self] in self.showProgress() })
            .disposed(by: disposeBag)
        
        output.failure
            .drive(onNext: { [unowned self] in
                self.hideProgress()
                self.showAlert(title: "Login Failed", message: $0)
            })
            .disposed(by: disposeBag)
        
        output.success
            .drive(onNext: { [unowned self] _ in
                self.hideProgress()
                self.coordinator.transition(to: .synchronization)
                    .subscribe(onCompleted: { [unowned self] in
                        self.tfPassword.text = nil
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
}
