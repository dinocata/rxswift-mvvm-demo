//
//  BindableType.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit

protocol BindableType {
    associatedtype VMType: ViewModelType
    
    var viewModel: VMType { get set }
    
    func createInput() -> VMType.Input
    func onCreateOutput(output: VMType.Output)
}

extension BindableType where Self: UIViewController {
    
    func bindViewModel() {
        onCreateOutput(output: viewModel.transform(input: createInput()))
    }
    
}
