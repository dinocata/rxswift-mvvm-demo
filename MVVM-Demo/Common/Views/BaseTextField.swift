//
//  BaseTextField.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 05/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit
import RxSwift

class BaseTextField: UITextField {
    
    var fieldModel: TextFieldVM?
    
    private var disposeBag = DisposeBag()
    
    func bindViewModel(_ viewModel: TextFieldVM) {
        self.fieldModel = viewModel
        
        self.rx.text.orEmpty
            .bind(to: viewModel.value)
            .disposed(by: disposeBag)
        
        viewModel.validationResult
            .asDriver(onErrorJustReturn: .failure("Unknown error"))
            .drive(onNext: { [unowned self] result in
                switch result {
                case .success:
                    self.resetState()
                    
                case .failure:
                    self.becomeFirstResponder() // Focuses the text field if the validation fails
                    self.setInvalidState()
                    // Do any extra behaviour here, for instance showing an error label on the text field.
                }
            })
            .disposed(by: disposeBag)
    }
    
    func resetState() {
        self.layer.borderWidth = 0
    }
    
    /// Adds a red border around the text field to indicate it is not valid.
    func setInvalidState() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.borderColor = Colors.red.cgColor
    }
    
}
