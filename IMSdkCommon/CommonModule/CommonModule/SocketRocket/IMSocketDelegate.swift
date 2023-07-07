//
//  SocketResponseModel.swift
//  socketDemo
//
//  Created by on 2021/8/4.
//

import Foundation

public typealias IMCommonClosure = (_ obj: Any?) -> Void
public typealias IMCommonErrorClosure = (_ error: Error) -> Void

@objc public enum IMSocketState: Int {
    case notConnect = 0
    case startConnect
    case connected
    case connectFail
    case closed
}

@objcMembers public class IMSocketResponseDelegate: NSObject {

    public var state: IMSocketState = .notConnect
    public var reConnectComplete: IMCommonClosure?
    
    public var didReceivePongClosure: IMCommonClosure?
    public var didOpenClosure: IMCommonClosure?
    public var didReceiveMessageClosure: IMCommonClosure?
    public var didFaildClosure: IMCommonErrorClosure?
    public var didCloseClosure: IMCommonClosure?
    
    @discardableResult
    public func didOpen(_ closure: IMCommonClosure?) -> Self {
        didOpenClosure = closure
        return self
    }
    
    @discardableResult
    public func didReceivePong(_ closure: IMCommonClosure?) -> Self {
        didReceivePongClosure = closure
        return self
    }
    
    @discardableResult
    public func didReceiveMessage(_ closure: IMCommonClosure?) -> Self {
        didReceiveMessageClosure = closure
        return self
    }
    
    @discardableResult
    public func didFaild(_ closure: IMCommonErrorClosure?) -> Self {
        didFaildClosure = closure
        return self
    }
    
    @discardableResult
    public func didClose(_ closure: IMCommonClosure?) -> Self {
        didCloseClosure = closure
        return self
    }
    
    public init(socket: IMSocketTool) {
        super.init()
        self.addNotification()
        
        SDKDebugLog("Debug Test Socket delegate init...")
        // try send heart to get current socket state
        socket.sendHeartBeat()
    }

    private func addNotification() {
                
        NotificationCenter.default.addObserver(self, selector: #selector(notificaDidOpen(notifcation:)), name: Notification.Name(rawValue: Socket_Notification_Name_DidOpen), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(notificaReceivePong(notifcation:)), name: Notification.Name(rawValue: Socket_Notification_Name_Pong), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(notificaReceiveMessage(notifcation:)), name: Notification.Name(rawValue: Socket_Notification_Name_ReceiveMessage), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificaFail(notifcation:)), name: Notification.Name(rawValue: Socket_Notification_Name_Fail), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(notificaDidClose(notifcation:)), name: Notification.Name(rawValue: Socket_Notification_Name_DidClose), object: nil)
    }

    
    @objc private func notificaDidOpen(notifcation: Notification) {
        state = .startConnect
        self.didOpenClosure?(nil)
    }
    
    @objc private func notificaReceivePong(notifcation: Notification) {
       
        if state != .connected {
            self.reConnectComplete?(nil)
        }
        
        state = .connected
        self.didReceivePongClosure?(nil)
    }
    
    @objc private func notificaReceiveMessage(notifcation: Notification) {
        
        if state != .connected {
            self.reConnectComplete?(nil)
        }
        
        state = .connected
        guard let info = notifcation.userInfo, let msg = info["value"] else {
            return
        }
        self.didReceiveMessageClosure?(msg)
    }
    
    @objc private func notificaFail(notifcation: Notification) {
        state = .connectFail
        guard let info = notifcation.userInfo, let error = info["value"] as? Error else {
            return
        }
        self.didFaildClosure?(error)
    }
    
    @objc private func notificaDidClose(notifcation: Notification) {
        state = .closed
        guard let info = notifcation.userInfo, let msg = info["value"] else {
            return
        }
        self.didCloseClosure?(msg)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("SocketResponseModel deinit!")
    }
}
