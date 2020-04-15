//
//  MVVMController.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MVVMController<ViewModel: ViewModelType>: UIViewController {
    
    var disposeBag = DisposeBag()
    
    private let viewModel: ViewModel
    
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindOutput(viewModel.transform(input: bindInput()))
    }
    
    func setupView() {
        // Override this method if you need to perform view initialization before binding the view model
    }
    
    func bindInput() -> ViewModel.Input {
        fatalError("Method needs to be implemented in a subclass")
    }
    
    func bindOutput(_ output: ViewModel.Output) {
        fatalError("Method needs to be implemented in a subclass")
    }
}
