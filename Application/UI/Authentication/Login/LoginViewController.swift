//
//  LoginViewController.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import UIKit
import RxCocoa

// sourcery: scene = login
class LoginViewController: MVVMController<LoginViewModel> {

  // MARK: View definition
  // TODO: Define views here

  // MARK: Setup
  override func setupView() {
    // TODO: View initialization
  }

  // MARK: View Model Binding
  override func bindInput() -> LoginViewModel.Input {
    // TODO: Add implementation
    return LoginViewModel.Input()
  }

  override func bindOutput(_ output: LoginViewModel.Output) {
    // TODO: Add implementation
  }
}
