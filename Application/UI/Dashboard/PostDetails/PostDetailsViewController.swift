//
//  PostDetailsViewController.swift
//  Application
//
//  Created by Dino Catalinac on 14/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import UIKit
import RxCocoa

// sourcery: scene = postDetails
class PostDetailsViewController: CoordinatorVC<PostDetailsViewModel> {
    
    // MARK: View definition
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    // MARK: Parameter
    // sourcery:begin: parameter
    var postId: Int!
    // sourcery:end
    
    // MARK: Setup
    override func setupView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.leftMargin).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.rightMargin).offset(-16)
        }
        
        self.view.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.bodyLabel.snp.leading)
            make.trailing.equalTo(self.bodyLabel.snp.trailing)
            make.top.equalTo(self.bodyLabel.snp.bottom).offset(8)
        }
    }
    
    // MARK: View Model Binding
    override func bindInput() -> PostDetailsViewModel.Input {
        return PostDetailsViewModel.Input(
            loadPost: .just(postId)
        )
    }
    
    override func bindOutput(_ output: PostDetailsViewModel.Output) {
        output.postData
            .drive(onNext: { [weak self] in self?.configure(with: $0) })
            .disposed(by: disposeBag)
        
        output.failure
            .drive(showAlert)
            .disposed(by: disposeBag)
        
        output.loading
            .drive(loading)
            .disposed(by: disposeBag)
    }
}

extension PostDetailsViewController: Configurable {
    
    struct Data {
        let title: String
        let body: String
        let author: String
    }
    
    func configure(with data: Data) {
        self.title = data.title
        self.bodyLabel.text = data.body
        self.authorLabel.text = data.author
    }
}
