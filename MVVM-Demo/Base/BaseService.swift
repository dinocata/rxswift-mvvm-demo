//
//  BaseService.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 03/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift

class BaseService {
    
    private var network: NetworkProtocol
    
    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func request<T: Decodable>(_ target: ApiService, responseType: T.Type) -> Single<NetworkResult<T>> {
        return network.request(target, responseType: responseType)
    }
    
}
