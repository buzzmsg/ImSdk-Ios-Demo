//
//  NC.swift
//  TMM
//
//  Created by    on 2022/5/23.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation


@objc public protocol IMEvent: NSObjectProtocol {
    @objc func getData() -> [String]
    @objc func getName() -> String
}


public typealias IMObserverClosure<T: IMEvent> = (_ event: T, _ observer: IMObserver<T>) -> Void

@objcMembers public class IMObserver<T: IMEvent>: NSObject {
    
    private var blk: IMObserverClosure<T>
    fileprivate(set) var eventName: String = ""

    public init(callBack blk: @escaping IMObserverClosure<T>) {
        self.blk = blk
    }
    
    public func notification(n: Notification) {
        self.blk(n.object as! T, self)
    }
    
    deinit {
    }
}
 
@objcMembers public class IMNotificationCenter: NSObject {
    
    private var observers: [NSObject: Bool] = [:]
    
    private(set) var notificationCenter: NotificationCenter
    
    private static var instance: IMNotificationCenter?
    
    public static func defualt() -> IMNotificationCenter {

        if instance == nil {
            instance = IMNotificationCenter.init(NotificationCenter.default)
        }
        
        return instance!
    }
    
    public init (_ notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    
    // MARK: -
    
    public func addObersver<T:IMEvent>(observer: IMObserver<T>, name forName: String) {
        observer.eventName = forName
        observers[observer] = true
        
        // func notification(n: Notification)
        let obserFuncName: String = "notificationWithN:"
        notificationCenter.addObserver(observer, selector: NSSelectorFromString(obserFuncName), name: Notification.Name(rawValue: forName), object: nil)
    }
    
    public func remove<T:IMEvent>(observer: IMObserver<T>) {
        observers.removeValue(forKey: observer)
        
        notificationCenter.removeObserver(observer)
    }
    
    public func post (event: IMEvent) {
        notificationCenter.post(name: Notification.Name(rawValue: event.getName()), object: event)
    }
}


