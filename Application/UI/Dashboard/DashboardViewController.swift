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
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cellType: PostListItemCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        return tableView
    }()
    
    private lazy var loginButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Login", style: .plain, target: self, action: nil)
        return button
    }()
    
    private lazy var logoutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: nil)
        return button
    }()
    
    // MARK: Input subjects
    private let loadingSubject = PublishRelay<Void>()
    
    // MARK: Setup
    override func setupView() {
        self.title = "Posts"
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.leftMargin)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.rightMargin)
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingSubject.accept(())
    }
    
    // MARK: View Model Binding
    override func bindInput() -> DashboardViewModel.Input {
        return DashboardViewModel.Input(
            loadPosts: loadingSubject.asDriver(onErrorJustReturn: ()),
            loginButtonPressed: loginButton.rx.tap.asDriver(),
            logoutButtonPressed: logoutButton.rx.tap.asDriver()
        )
    }
    
    override func bindOutput(_ output: DashboardViewModel.Output) {
        output.postData
            .drive(tableView.rx.items(cellType: PostListItemCell.self)) { $2.configure(with: $1) }
            .disposed(by: disposeBag)
        
        output.isLoggedIn
            .map { [weak self] in $0 ? self?.logoutButton : self?.loginButton }
            .drive(onNext: { [weak self] in
                self?.navigationItem.rightBarButtonItem = $0
            })
            .disposed(by: disposeBag)
        
        output.failure
            .drive(showAlert)
            .disposed(by: disposeBag)
        
        output.loading
            .drive(loading)
            .disposed(by: disposeBag)
        
        output.logout
            .drive()
            .disposed(by: disposeBag)
        
        output.transition
            .drive(transition)
            .disposed(by: disposeBag)
    }
}
