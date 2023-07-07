//
//  IMNotificationManager.swift
//  TEST
//
//  Created by  on 2021/8/3.
//

import UIKit

fileprivate extension NSObject {
    
    private struct AssociatedKey {
        static var observersKey: String = NSStringFromClass(IMNotificationManager.classForCoder())
    }
    
    func getObservers<T: IMEvent>() -> [IMObserver<T>] {
        if let ary: [IMObserver<T>] = objc_getAssociatedObject(self, &AssociatedKey.observersKey) as? [IMObserver<T>] {
            return ary
        }
        return [IMObserver<T>]()
    }
    
    func appendObserver<T: IMEvent>(observer: IMObserver<T>) {
        var old: [IMObserver<T>] = getObservers()
        old.append(observer)
        objc_setAssociatedObject(self, &AssociatedKey.observersKey, old, .OBJC_ASSOCIATION_COPY)
    }
    
    
    func cleanObservers() {
        objc_setAssociatedObject(self, &AssociatedKey.observersKey, nil, .OBJC_ASSOCIATION_ASSIGN)
    }
    
    func updateObservers<T: IMEvent>(_ observers: [IMObserver<T>]) {
        objc_setAssociatedObject(self, &AssociatedKey.observersKey, observers, .OBJC_ASSOCIATION_COPY)
    }
}

@objcMembers public class IMNotificationManager:NSObject {
        
    let ncCore: IMNotificationCenter!
        
    public init(notific: IMNotificationCenter) {
        ncCore = notific
    }
    
    
    // MARK: - post

    public func post(eventProtocol : IMEvent) {
        ncCore.post(event: eventProtocol)
    }

    // MARK: - add

    func observer<T: IMEvent>(_ observer : NSObject , _ name : String ,_ block : @escaping IMObserverClosure<T>) {
        let newObse: IMObserver = IMObserver(callBack: block)
        observer.appendObserver(observer: newObse)
        ncCore.addObersver(observer: newObse, name: name)
    }
    
    
    // MARK: - remove

    public func removeObserver(_ observer : NSObject) {

        let old: [IMObserver<IMEvent>] = observer.getObservers()
        old.forEach { ob in
            ncCore.remove(observer: ob)
        }
        observer.cleanObservers()
    }

    public func removeObserver(_ observer : NSObject, forName: String) {
        var old: [IMObserver<IMEvent>] = observer.getObservers()
        old.forEach { ob in
            if ob.eventName == forName {
                ncCore.remove(observer: ob)
            }
        }
        
        old.removeAll { ob in
            ob.eventName == forName
        }
        observer.updateObservers(old)
    }
    
    // MARK: - only for old
    
    public typealias NoticeBlock = (_ object:Any? ,_ userInfo:Any?)->()

    public func observer(_ observer : NSObject , _ name : String ,_ block : @escaping NoticeBlock) {
        
        self.observer(observer, name) { (event: IMEvent, observer: IMObserver<IMEvent>) in
            block(observer, event)
        }
    }
}


