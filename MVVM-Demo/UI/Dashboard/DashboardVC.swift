//
//  DashboardVC.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 06/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit
import RxSwift

class DashboardVC: BaseVC<DashboardVM>, BindableType {
    
    // Outlets
    @IBOutlet weak var btnArticles: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dashboard"
        bindViewModel()
    }
    
    func createInput() -> DashboardVM.Input {
        return DashboardVM.Input(articles: btnArticles.rx.tap.asDriver(),
                                 logout: btnLogout.rx.tap.asDriver())
    }
    
    func onCreateOutput(output: DashboardVM.Output) {
        output.articles
            .drive(onNext: { [unowned self] in self.coordinator.transition(to: .articleList) })
            .disposed(by: disposeBag)
        
        output.logout
            .drive(onNext: { [unowned self] in
                // Completable is always disposed on completion, so we don't need to add it to the dispose bag
                self.coordinator.pop(animated: false)
                    .subscribe(onCompleted: { [unowned self] in
                        self.coordinator.popToRoot(animated: true)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
}
