//
//  CoordinatorVC.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 02/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit
import RxSwift
import MBProgressHUD

class CoordinatorVC: UIViewController {
    var coordinator: SceneCoordinatorType!
    var disposeBag = DisposeBag()
    
    private var progressHud: MBProgressHUD?
    
    required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinator.currentViewController = actualViewController()
    }
    
    func showProgress(disableInteraction: Bool = true) {
        view.isUserInteractionEnabled = !disableInteraction
        
        hideProgress()
        progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud!.mode = .indeterminate
        progressHud!.removeFromSuperViewOnHide = true
    }
    
    func hideProgress() {
        view.isUserInteractionEnabled = true
        
        if progressHud != nil {
            progressHud?.hide(animated: true)
            progressHud = nil
        }
    }
}