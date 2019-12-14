//
//  MVVMController.swift
//  PresentationPlatform
//
//  Created by Dino Catalinac on 14/12/2019.
//  Copyright © 2019 DinoCata. All rights reserved.
//

import UIKit
import RxSwift

open class MVVMController<T: ViewModel>: UIViewController {
    
    var viewModel: T
    var disposeBag = DisposeBag()
    
    required public init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        bindOutput(output: viewModel.transform(input: bindInput()))
    }
    
    func bindInput() -> T.Input {
        fatalError("createInput() has not been implemented")
    }
    
    func bindOutput(output: T.Output) {
        fatalError("onCreateOutput(output: ViewModelType.Output) has not been implemented")
    }
}
