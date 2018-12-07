//
//  DashboardVC.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 06/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit

class DashboardVC: BaseVC<DashboardVM>, BindableType {
    
    // Outlets
    @IBOutlet weak var btnArticles: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dashboard"
        bindViewModel()
    }
    
    func generateInputs() -> DashboardVM.Input {
        return DashboardVM.Input(articles: btnArticles.rx.tap.asDriver(),
                                 logout: btnLogout.rx.tap.asDriver())
    }
    
    func onGenerateOutputs(outputs: DashboardVM.Output) {
        outputs.articles
            .drive(onNext: { [weak self] in
                self?.coordinator.transition(to: .articleList)
            })
            .disposed(by: disposeBag)
        
        outputs.logout
            .drive(onNext: { [weak self] in
                // Completable is always disposed on completion, so we don't need to add it to the dispose bag
                _ = self?.coordinator.pop(animated: false)
                    .subscribe(onCompleted: {
                        self?.coordinator.popToRoot(animated: true)
                    })
            })
            .disposed(by: disposeBag)
    }
    
}
