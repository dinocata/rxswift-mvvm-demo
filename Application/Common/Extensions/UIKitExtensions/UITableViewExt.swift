//
//  UITableViewExt.swift
//  Application
//
//  Created by Dino Catalinac on 14/04/2020.
//  Copyright © 2020 https://github.com/AliSoftware/Reusable
//

import UIKit

extension UITableView {
    
    final func register<T: UITableViewCell>(cellType: T.Type) {
        self.register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self)."
            )
        }
        return cell
    }
}
