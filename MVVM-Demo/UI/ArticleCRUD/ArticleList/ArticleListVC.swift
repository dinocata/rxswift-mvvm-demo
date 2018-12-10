//
//  ArticleListVC.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit

class ArticleListVC: BaseVC<ArticleListVM>, BindableType {
    
    // Outlets
    @IBOutlet weak var loadBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Articles"
        bindViewModel()
    }
    
    func generateInputs() -> ArticleListVM.Input {
        let inputs = ArticleListVM.Input()
        
        loadBtn.rx.tap
            .bind(to: inputs.load)
            .disposed(by: disposeBag)
        
        return inputs
    }
    
    func onGenerateOutputs(outputs: ArticleListVM.Output) {
        outputs.data
            .drive(onNext: { items in
                for item in items {
                    print("Name:" + item.name)
                }
            })
            .disposed(by: disposeBag)
    }
    
}
