//
//  UITableViewRx.swift
//  Application
//
//  Created by Dino Catalinac on 14/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    
    func items<Sequence: Swift.Sequence, Cell: UITableViewCell, Source: ObservableType>(cellType: Cell.Type = Cell.self)
        -> (_ source: Source)
        -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
        -> Disposable where Source.Element == Sequence {
        return self.items(cellIdentifier: cellType.reuseIdentifier, cellType: cellType)
    }
}
