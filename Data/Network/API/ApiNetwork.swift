//
//  ApiNetwork.swift
//  Data
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Moya
import RxSwift
import Domain

// sourcery: injectable = ApiNetwork, singleton
public protocol NetworkProtocol {
    func request<T: Decodable>(_ target: ApiService,
                               responseType: T.Type,
                               retries: Int) -> Single<NetworkResult<T>>
}

extension NetworkProtocol {
    func request<T: Decodable>(_ target: ApiService,
                               responseType: T.Type = T.self,
                               retries: Int = 1) -> Single<NetworkResult<T>> {
        request(target, responseType: responseType, retries: retries)
    }
}

public class ApiNetwork: NetworkProtocol {
    
    // sourcery: inject = MoyaProvider<ApiService>
    public var provider: MoyaProvider<ApiService>!
    
    public init() {}
    
    public func request<T: Decodable>(_ target: ApiService, responseType: T.Type, retries: Int) -> Single<NetworkResult<T>> {
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .retry(retries)
            .map(responseType)
            .map { NetworkResult<T>.success($0) }
            // Handle the error however you want
            .catchError { error -> Single<NetworkResult<T>> in
                guard let moyaError = error as? MoyaError, let response = moyaError.response else {
                    return .just(.failure(.unrecognized))
                }
                return .just(.failure(NetworkError(rawValue: response.statusCode) ?? .unrecognized))
        }
    }
}
