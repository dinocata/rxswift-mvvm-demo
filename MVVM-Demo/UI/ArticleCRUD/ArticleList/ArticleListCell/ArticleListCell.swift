//
//  ArticleListCell.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 11/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit

class ArticleListCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(item: ArticleListItemVM) {
        self.lblName.text = "\(item.name ?? "") (\(item.id))"
        self.lblDescription.text = item.description
        self.lblPrice.text = item.price
    }
    
}
