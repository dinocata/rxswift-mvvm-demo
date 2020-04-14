//
//  CoordinatorVC.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import UIKit
import RxCocoa
import MBProgressHUD

class CoordinatorVC<ViewModel: ViewModelType>: MVVMController<ViewModel> {
    
    var coordinator: SceneCoordinatorType
    
    var transition: Binder<Scene> {
        return Binder(self) { viewController, scene in
            viewController.coordinator.currentViewController = viewController
            viewController.coordinator.transition(to: scene)
        }
    }
    
    var dismiss: Binder<Void> {
        return Binder(self) { viewController, _ in
            viewController.coordinator.currentViewController = viewController
            viewController.coordinator.pop(animated: true, completion: nil)
        }
    }
    
    var loading: Binder<Bool> {
        return Binder(self) { viewController, isLoading in
            if isLoading {
                viewController.showProgress()
            } else {
                viewController.hideProgress()
            }
        }
    }
    
    var showAlert: Binder<String> {
        return Binder(self) { viewController, message in
            viewController.showAlert(title: message)
        }
    }
    
    private var progressHud: MBProgressHUD?
    
    required init(viewModel: ViewModel, coordinator: SceneCoordinatorType) {
        self.coordinator = coordinator
        self.coordinator.sceneCount += 1
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(viewModel: ViewModel) {
        fatalError("init(viewModel:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinator.currentViewController = self.actualViewController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let presenter = presentingViewController {
            coordinator.currentViewController = presenter.actualViewController
        }
    }
    
    func showProgress(disableInteraction: Bool = true) {
        view.isUserInteractionEnabled = !disableInteraction
        
        hideProgress()
        progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud?.mode = .indeterminate
        progressHud?.removeFromSuperViewOnHide = true
    }
    
    func hideProgress() {
        view.isUserInteractionEnabled = true
        
        if progressHud != nil {
            progressHud?.hide(animated: true)
            progressHud = nil
        }
    }
    
    func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    deinit {
        coordinator.sceneCount -= 1
    }
}
