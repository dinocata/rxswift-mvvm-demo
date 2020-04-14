//
//  StartScreenViewController.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import UIKit
import Domain
import RxCocoa
import SnapKit

// sourcery: scene = startScreen, transition = root, navigation
class StartScreenViewController: CoordinatorVC<StartScreenViewModel> {
    
    // MARK: View definition
    private lazy var dashboardButton: UIButton = {
        let button = UIButton()
        button.setTitle("DASHBOARD", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var loginButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Login", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = button
        return button
    }()
    
    // MARK: Setup
    override func setupView() {
        self.title = "MVVM Demo"
        self.view.backgroundColor = .white
        
        self.view.addSubview(dashboardButton)
        dashboardButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: View Model Binding
    override func bindInput() -> StartScreenViewModel.Input {
        return .init(
            dashboardButtonPressed: self.dashboardButton.rx.tap.asDriver(),
            loginButtonPressed: self.loginButton.rx.tap.asDriver()
        )
    }
    
    override func bindOutput(_ output: StartScreenViewModel.Output) {
        output.transition
            .drive(transition)
            .disposed(by: disposeBag)
    }
}
