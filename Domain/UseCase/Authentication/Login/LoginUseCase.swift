//
//  LoginUseCase.swift
//  Domain
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 UHP. All rights reserved.
//

import RxSwift

// sourcery: injectable
public protocol LoginUseCase {
    func login(email: String, password: String) -> Single<NetworkResult<LoginResponseData>>
}
