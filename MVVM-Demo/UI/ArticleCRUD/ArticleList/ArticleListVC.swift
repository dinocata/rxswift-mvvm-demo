//
//  ArticleListVC.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit

class ArticleListVC: BaseVC<ArticleListVM>, BindableType {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Articles"
        bindViewModel()
    }

    func generateInputs() -> ArticleListVM.Input {
        return ArticleListVM.Input()
    }
    
    func onGenerateOutputs(outputs: ArticleListVM.Output) {
        
    }

}
