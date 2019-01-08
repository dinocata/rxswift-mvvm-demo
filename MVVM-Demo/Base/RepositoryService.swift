//
//  RepositoryService.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 08/01/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import RxSwift

class RepositoryService<T: Populatable>: BaseService {
    
    private let repository: BaseRepositoryImpl<T>
    
    init(repository: BaseRepositoryImpl<T>, network: NetworkProtocol) {
        self.repository = repository
        super.init(network: network)
    }
    
    func fetchApiData(_ target: ApiService) -> Observable<[T]> {
        return request(target, responseType: [T.DataType].self)
            .map {
                switch $0 {
                case .success(let data):
                    return data
                default:
                    return []
                }
            }
            .asObservable()
            .flatMap { [unowned self] in self.repository.saveList($0) }
    }
}
