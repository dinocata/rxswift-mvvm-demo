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
    
    // Parameters
    // sourcery:begin: parameter
    var resultNotifier: PublishRelay<LoginEvent>!
    // sourcery:end
    
    // MARK: View definition
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
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
    }
    
    // MARK: View Model Binding
    override func bindInput() -> LoginViewModel.Input {
        return .init(
            closeButtonPressed: self.closeButton.rx.tap.asDriver()
        )
    }
    
    override func bindOutput(_ output: LoginViewModel.Output) {
        output.close
            .drive(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.coordinator.pop(animated: true) {
                    self.resultNotifier.accept(.cancel)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
