//
//  ArticleDetailsVC.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 17/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit

class ArticleDetailsVC: BaseVC<ArticleDetailsVM>, BindableType {
    
    // Outlets
    @IBOutlet weak var tfArticleId: BaseTextField!
    @IBOutlet weak var tfArticleName: BaseTextField!
    @IBOutlet weak var tfArticleDescription: BaseTextField!
    @IBOutlet weak var tfArticlePrice: BaseTextField!
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func createInput() -> ArticleDetailsVM.Input {
        tfArticleId.bindViewModel(TextFieldVM())
        tfArticleName.bindViewModel(TextFieldVM())
        tfArticleDescription.bindViewModel(TextFieldVM())
        tfArticlePrice.bindViewModel(TextFieldVM())
        
        return ArticleDetailsVM.Input(id: tfArticleId.fieldModel!,
                                      name: tfArticleName.fieldModel!,
                                      description: tfArticleDescription.fieldModel!,
                                      price: tfArticlePrice.fieldModel!,
                                      confirm: btnSave.rx.tap.asDriver())
    }
    
    func onCreateOutput(output: ArticleDetailsVM.Output) {
        output.title
            .drive(self.rx.title)
            .disposed(by: disposeBag)
        
        output.wrapper
            .drive(onNext: { [unowned self] item in
                self.tfArticleId.isHidden = true
                self.tfArticleId.text = item.id
                self.tfArticleName.text = item.name
                self.tfArticleDescription.text = item.description
                self.tfArticlePrice.text = item.price
            })
            .disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { [unowned self] in self.showAlert(title: "Failure", message: $0) })
            .disposed(by: disposeBag)
        
        output.confirm
            .drive(onNext: { [unowned self] _ in
                self.disposeBindings()
                self.coordinator.pop(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
