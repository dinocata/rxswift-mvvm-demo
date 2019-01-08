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

/// Wrapper for Moya requests, which wraps the responses in a NetworkResult observable.
/// Feel free to extend this to your custom behaviour (for instance, preventing requests if App is incompatible, handling special status codes etc.)
/// TODO: missing method for performing a progress-type request.
protocol NetworkProtocol {
    
    /// Performs API request.
    ///
    /// - Parameters:
    ///   - target: Target API endpoint
    ///   - responseType: Type of data to parse the response to
    /// - Returns: Response result wrapped in a observable
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
            .map { NetworkResult<T>.success($0) }
            .catchError { Single.just(.failure(NetworkError(error: $0 as? MoyaError))) }
    }
}

class ApiNetwork: Network<ApiService>, NetworkProtocol {}
