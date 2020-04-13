//
//  NetworkError.swift
//  Domain
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import Foundation

public typealias NetworkResult<ResponseData> = Result<ResponseData, NetworkError>

public enum NetworkError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case notAcceptable = 406
    case notAllowed = 409
    case teapot = 418
    case unprocessableEntity = 422
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case unrecognized = -1
    case parseError = -2
}
