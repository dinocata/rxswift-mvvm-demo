//
//  UserService.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 03/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import RxSwift

protocol UserService {
    func login(_ requestBody: LoginRequest) -> Single<ResponseStatus>
}
