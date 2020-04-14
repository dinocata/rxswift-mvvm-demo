//
//  KeychainAccessManager.swift
//  Data
//
//  Created by Dino Catalinac on 14/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import KeychainAccess
import RxSwift

// sourcery: injectable, singleton
public protocol KeychainAccessManager {
    var authToken: String? { get set }
    
    func getAuthToken() -> Observable<String?>
}

public class KeychainAccessManagerImpl: KeychainAccessManager {
    
    private struct Keys {
        static let service = "mvvm-demo-token"
        static let authToken = "auth_token"
    }
    
    public var notificationManager: NotificationManager!
    
    private let keychain: Keychain = {
        return Keychain(service: Keys.service)
    }()
    
    public var authToken: String? {
        get { keychain[Keys.authToken] }
        set {
            keychain[Keys.authToken] = newValue
            notificationManager.post(notification: .authTokenChange, object: nil)
        }
    }
    
    public func getAuthToken() -> Observable<String?> {
        return notificationManager
            .observe(notification: .authTokenChange)
            .map { _ in }
            .startWith(())
            .map { self.authToken }
    }
    
    public init() {}
}
