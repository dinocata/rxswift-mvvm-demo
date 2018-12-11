//
//  UserServiceImpl.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 11/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift

class UserServiceImpl: BaseService, UserService {
    
    private let keychainAccess: KeychainAccessHelper
    
    init(keychainAccess: KeychainAccessHelper, network: NetworkProtocol) {
        self.keychainAccess = keychainAccess
        super.init(network: network)
    }
    
    func login(_ requestBody: LoginRequest) -> Single<ResponseStatus> {
        return request(.login(requestBody), responseType: LoginResponse.self)
            .map { [unowned self] result in
                switch result {
                case .success(let data):
                    self.keychainAccess.setUserToken(data.token)
                    return .success
                case .error(let error):
                    return error.status
                }
        }
    }
    
}
