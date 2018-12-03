//
//  Network.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 03/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Moya
import RxSwift

typealias NetworkResult<T> = Result<T, NetworkError>

/// Wrapper that handles response errors
struct NetworkError: Error {
    let status: ResponseStatus
    var errorMessage: String
    
    init(error: MoyaError?) {
        if let response = error?.response {
            let decodedStatus = ResponseStatus.getByCode(code: response.statusCode)
            if decodedStatus == .success { // If response was succesful, but JSON parsing failed
                status = .parseError
            } else {
                status = decodedStatus
            }
        } else {
            status = .unrecognized
        }
        errorMessage = status.errorDescription
    }
    
}

protocol NetworkProtocol {
    func request<T: Decodable>(_ target: ApiService, responseType: T.Type) -> Single<NetworkResult<T>>
}

class Network<ApiTarget: TargetType> {
    
    private let provider: MoyaProvider<ApiTarget>
    
    init(provider: MoyaProvider<ApiTarget>) {
        self.provider = provider
    }
    
    func request<T: Decodable>(_ target: ApiTarget, responseType: T.Type) -> Single<NetworkResult<T>> {
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .map(responseType)
            .map { Result<T, NetworkError>.success($0) }
            .catchError { Single.just(.error(NetworkError(error: $0 as? MoyaError))) }
    }
}

class ApiNetwork: Network<ApiService>, NetworkProtocol {}
