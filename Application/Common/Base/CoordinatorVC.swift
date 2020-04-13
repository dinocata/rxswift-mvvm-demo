//
//  CoordinatorVC.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import UIKit
import RxCocoa

class CoordinatorVC<ViewModel: ViewModelType>: MVVMController<ViewModel> {
    
    var coordinator: SceneCoordinatorType
    
    var transition: Binder<Scene> {
        return Binder(self) { viewController, scene in
            viewController.coordinator.transition(to: scene)
        }
    }
    
    var dismiss: Binder<Void> {
        return Binder(self) { viewController, _ in
            viewController.coordinator.pop(animated: true, completion: nil)
        }
    }
    
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
    
    deinit {
        coordinator.sceneCount -= 1
    }
}
