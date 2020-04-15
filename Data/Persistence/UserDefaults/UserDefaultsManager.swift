//
//  UserDefaultsManager.swift
//  Data
//
//  Created by Dino Catalinac on 15/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift

// sourcery: injectable, singleton
public protocol UserDefaultsManager {
    func storeEncodable<T: Encodable>(_ object: T, key: String)
    func fetchDecodable<T: Decodable>(type: T.Type, key: String) -> T?
    func observeDecodable<T: Decodable>(type: T.Type, key: String) -> Observable<T?>
}

extension UserDefaultsManager {
    func fetchDecodable<T: Decodable>(type: T.Type = T.self, key: String) -> T? {
        return fetchDecodable(type: type, key: key)
    }
    
    func observeDecodable<T: Decodable>(type: T.Type = T.self, key: String) -> Observable<T?> {
        return observeDecodable(type: type, key: key)
    }
}

public class UserDefaultsManagerImpl: UserDefaultsManager {
    
    struct Keys {
        static let currentUser = "current_user"
    }
    
    public init() {}
    
    public func storeEncodable<T: Encodable>(_ object: T, key: String) {
        if let data = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    public func fetchDecodable<T: Decodable>(type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    public func observeDecodable<T: Decodable>(type: T.Type, key: String) -> Observable<T?> {
        return UserDefaults.standard.rx.observe(Data.self, key)
            .map { object -> T? in
                guard let object = object else {
                    return nil
                }
                return try? JSONDecoder().decode(T.self, from: object)
        }
    }
}
