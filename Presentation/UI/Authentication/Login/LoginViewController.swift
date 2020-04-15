//
//  LoginViewController.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import UIKit
import RxCocoa
import Domain

// sourcery: scene = login, transition = modal
class LoginViewController: CoordinatorVC<LoginViewModel> {
    
    // MARK: View definition
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var formStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        // Test
        textField.text = "eve.holt@reqres.in"
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.text = "cityslicka"
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: Setup
    override func setupView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        self.view.addSubview(formStackView)
        formStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        
        formStackView.addArrangedSubview(emailTextField)
        formStackView.addArrangedSubview(passwordTextField)
        formStackView.addArrangedSubview(submitButton)
    }
    
    // MARK: View Model Binding
    override func bindInput() -> LoginViewModel.Input {
        return .init(
            email: emailTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            submit: submitButton.rx.tap.asDriver(),
            closeButtonPressed: closeButton.rx.tap.asDriver()
        )
    }
    
    override func bindOutput(_ output: LoginViewModel.Output) {
        output.submitEnabled
            .drive(submitButton.rx.enabled)
            .disposed(by: disposeBag)
        
        output.close
            .drive(dismiss)
            .disposed(by: disposeBag)
        
        output.failure
            .drive(showAlert)
            .disposed(by: disposeBag)
        
        output.loading
            .drive(loading)
            .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
