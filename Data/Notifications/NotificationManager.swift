//
//  NotificationManager.swift
//  Data
//
//  Created by Dino Catalinac on 14/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift
import RxCocoa

// sourcery: injectable, singleton
public protocol NotificationManager {
    func observe(notification: Notification.Name) -> Observable<Notification>
    func post(notification: Notification.Name, object anObject: Any?)
}

public class NotificationManagerImpl: NotificationManager {
    
    public init() {}
    
    public func observe(notification: Notification.Name) -> Observable<Notification> {
        return NotificationCenter.default.rx.notification(notification)
    }
    
    public func post(notification: Notification.Name, object anObject: Any?) {
        NotificationCenter.default.post(name: notification, object: anObject)
    }
}
