//
//  DashboardViewController.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import UIKit
import RxCocoa

// sourcery: scene = dashboard
class DashboardViewController: CoordinatorVC<DashboardViewModel> {
    
    // MARK: View definition
    // TODO: Define views here
    
    // MARK: Input subjects
    private let loadingSubject = PublishRelay<Void>()
    
    // MARK: Setup
    override func setupView() {
        self.title = "Dashboard"
        
        self.view.backgroundColor = .lightGray
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingSubject.accept(())
    }
    
    // MARK: View Model Binding
    override func bindInput() -> DashboardViewModel.Input {
        return DashboardViewModel.Input(
            loadPosts: loadingSubject.asDriver(onErrorJustReturn: ())
        )
    }
    
    override func bindOutput(_ output: DashboardViewModel.Output) {
        output.postData
            .drive(onNext: { data in
                print(data)
            })
            .disposed(by: disposeBag)
        
        output.failure
            .drive(showAlert)
            .disposed(by: disposeBag)
        
        output.loading
            .drive(loading)
            .disposed(by: disposeBag)
    }
}
