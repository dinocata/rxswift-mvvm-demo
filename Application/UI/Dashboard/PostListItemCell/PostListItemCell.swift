//
//  PostListItemCell.swift
//  Application
//
//  Created by Dino Catalinac on 14/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import UIKit
import SnapKit

class PostListItemCell: UITableViewCell {
    
    // MARK: View definition
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(8)
            make.right.bottom.equalToSuperview().offset(-8)
        }
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(authorLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // NOOP
    }
}

extension PostListItemCell: Configurable {
    
    struct Data {
        let title: String
        let author: String
    }
    
    func configure(with data: Data) {
        self.titleLabel.text = data.title
        self.authorLabel.text = data.author
    }
}
