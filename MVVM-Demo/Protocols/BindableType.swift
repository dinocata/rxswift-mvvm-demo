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
    
    func generateInputs() -> VMType.Input
    func onGenerateOutputs(outputs: VMType.Output)
}

extension BindableType where Self: UIViewController {
    
    func bindViewModel() {
        onGenerateOutputs(outputs: viewModel.transform(input: generateInputs()))
    }
    
}
