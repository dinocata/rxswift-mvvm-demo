//
//  ArticleListVC.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit

class ArticleListVC: BaseVC<ArticleListVM>, BindableType, UITableViewDelegate {
    
    // Outlets
    @IBOutlet weak var tvArticleList: UITableView!
    
    // Vars
    private var inputs: ArticleListVM.Input!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Articles"
        setupViews()
        bindViewModel()
    }
    
    func setupViews() {
        tvArticleList.registerCellNib(reuseIdentifier: ArticleListCell.reuseID)
        tvArticleList.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputs.data.onNext(())
    }
    
    func generateInputs() -> ArticleListVM.Input {
        let addArticleBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = addArticleBtn
        
        inputs = ArticleListVM.Input(create: addArticleBtn.rx.tap.asDriver(),
                                     selection: tvArticleList.rx.itemSelected.asDriver())
        return inputs
    }
    
    func onGenerateOutputs(outputs: ArticleListVM.Output) {
        outputs.data
            .drive(tvArticleList.rx.items(cellIdentifier: ArticleListCell.reuseID,
                                          cellType: ArticleListCell.self))
            { tv, item, cell in
                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
        
        outputs.details
            .drive(onNext: { [unowned self] in self.coordinator.transition(to: .articleDetails(id: $0)) })
            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
