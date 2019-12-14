//
//  NotificationManager.swift
//  PersistencePlatform
//
//  Created by Dino Catalinac on 14/12/2019.
//  Copyright © 2019 DinoCata. All rights reserved.
//

import RxSwift
import RxCocoa

// sourcery: factory = NotificationManagerImpl, singleton
public protocol NotificationManager {
    func register(notification: Notification.Name) -> Observable<Notification>
    func post(notification: Notification.Name, object anObject: Any?)
}

public class NotificationManagerImpl: NotificationManager {
    
    public init() {}
    
    public func register(notification: Notification.Name) -> Observable<Notification> {
        return NotificationCenter.default.rx.notification(notification)
    }
    
    public func post(notification: Notification.Name, object anObject: Any?) {
        NotificationCenter.default.post(name: notification, object: anObject)
    }
}
