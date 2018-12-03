//
//  ResponseStatus.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 03/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import Foundation

// Standard status codes (add any that are missing and are used in app)
enum ResponseStatus: Int {
    case success = 200
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
    case loading = -3 // Use to indicate when the request is still processing
    
    var errorDescription: String {
        switch self {
        case .unauthorized:
            return "Not authorized."
        case .internalServerError:
            return "Internal Server error."
        case .serviceUnavailable:
            return "Server is down."
        case .parseError:
            return "Response JSON could not be parsed."
        case .unrecognized:
            return "An unknown error occurred on the API request."
        default:
            return String(describing: self)
        }
    }
    
    static func getByCode(code: Int) -> ResponseStatus {
        switch code {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 406:
            return .notAcceptable
        case 409:
            return .notAllowed
        case 418:
            return .teapot
        case 422:
            return .unprocessableEntity
        case 500:
            return .internalServerError
        case 501:
            return .notImplemented
        case 502:
            return .badGateway
        case 503:
            return .serviceUnavailable
        case 200...399:
            return .success
        default:
            return .unrecognized
        }
    }
}
