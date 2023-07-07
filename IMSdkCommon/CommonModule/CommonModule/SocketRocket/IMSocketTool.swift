//
//  SocketTool.swift
//  socketDemo
//
//  Created by on 2021/8/3.
//

import Foundation
//import Localize_Swift

let Socket_Notification_Name_DidOpen = "Socket_Notification_Name_DidOpen"
let Socket_Notification_Name_Fail = "Socket_Notification_Name_Fail"
let Socket_Notification_Name_Pong = "Socket_Notification_Name_Pong"
let Socket_Notification_Name_ReceiveMessage = "Socket_Notification_Name_ReceiveMessage"
let Socket_Notification_Name_DidClose = "Socket_Notification_Name_DidClose"

@objcMembers public class IMSocketTool: NSObject, IMSRWebSocketDelegate {
    
    private var socketObj: IMSRWebSocket?
    private var heartBeatTimeInterval = 30.0
    private var hTimer: Timer?
    private var socketUrlStr: String?
    private var closeSocketWithUser = false
    
    private var pongTimeinterval = 0
    
//    public func initSocketTest(netFactory: IMNetFactory, deviceId: String) {
//
//        let tempNet = netFactory.getNetByServiceName(serviceName: IMSDKApiServiceName)
//        tempNet.getToken().then { [weak self] tokenStr -> Promise<Void> in
//
//            guard let self = self else {
//                return Promise<Void>.reject(IMNetworkingError.createCommonError())
//            }
//
//            if tokenStr.count <= 0 {
//                return Promise<Void>.reject(IMNetworkingError.createCommonError())
//            }
//
//            let net = netFactory.getNetByServiceName(serviceName: IMSDKSocketServiceName)
//            let host: String = net.getHost()
//            let over: String = UIDevice.current.systemVersion
//            let version: String = TMMGenerated.getBundleInfo(with: .appVersion)
//
//            let value = Localize.currentLanguage()
//            var lang = TMMLanguage.getCurrentLanguage(systemTag: value)
//            if lang == "zh-Hans" || lang == "zh-hant" {
//                lang = "cn"
//            }
//
//            let reqiD: String = IMDefine.get_ONLYID()
//            let str = host + "?device_id=\(deviceId)&over=\(over)&version=\(version)&lang=\(lang)&req_id=\(reqiD)&token=" + tokenStr
//            SDKDebugLog("Debug Test Socket start init: \(str)")
//
//            self.initSocket(url: str)
//
//            return Promise<Void>.resolve()
//        }
//    }
    
    public func initSocket(url: String) {
        guard let socketURL = URL(string: url) else {
            return
        }
        
        if let originSocket = socketObj, originSocket.readyState == .OPEN {
            SDKDebugLog("Debug Test Socket already init, start send heartBeat")
            sendHeartBeat()
            return
        }
        
        if let originSocket = socketObj, originSocket.readyState != .OPEN {
            
            closeSocketWithUser = true
            closeSocket()
            cleanObj()
            socketUrlStr = nil
            closeSocket()
            
            originSocket.delegate = nil
            originSocket.close()
            socketObj = nil
        }
        
        socketUrlStr = url
        SDKDebugLog("Debug Test Socket start init!")
        let socket = IMSRWebSocket(url: socketURL)
        socket?.delegate = self
        socket?.open()
        socketObj = socket
        
        closeSocketWithUser = false
    }
    
    public func closeSocketWithLogOut() {
        closeSocketWithUser = true
        closeSocket()
        cleanObj()
        socketUrlStr = nil
        closeSocket()
    }
    
    private func cleanObj() {
        destoryHeartBeatTimer()
        socketObj?.delegate = nil
        socketObj = nil
    }
    
    // MARK: -

    func closeSocket() {
        guard let socket = socketObj else {
            return
        }
        socket.close()
    }
    
    func sendData(data: Any) {
        guard let socket = socketObj else {
            return
        }
        
        guard socket.readyState == IMSRReadyState.OPEN else {
            reConnect()
            return
        }
        
        socket.send(data)
    }
    
    func sendHeartBeat() {
        SDKDebugLog("Debug Test Socket send heartBeat")
        if socketObj == nil || socketObj?.readyState != IMSRReadyState.OPEN {
            SDKDebugLog("Debug Test Socket send heartBeat, not open!!!")
            return
        }
        
        let heart = "Heart Beat"
        let data = heart.data(using: .utf8)
        socketObj?.sendPing(data)
    }
    
    func reConnect() {
        SDKDebugLog("Debug Test Socket restart init 1")
        closeSocketWithUser = true
        closeSocket()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let url = self?.socketUrlStr else {
                return
            }
            SDKDebugLog("Debug Test Socket restart init 2")
            self?.initSocket(url: url)
        }
    }
    
    private func startSendHeartBeatWithTimer() {
        SDKDebugLog("Debug Test Socket startSendHeartBeatWithTimer")
        destoryHeartBeatTimer()
        
        guard let socket = socketObj, socket.readyState == IMSRReadyState.OPEN else {
            return
        }
        
        let timer = Timer.init(timeInterval: heartBeatTimeInterval, repeats: true) { [weak self] (timer) in
            guard let self = self else { return }
            SDKDebugLog("Debug Test Socket timer run, start send heartBeat")
            if self.pongTimeinterval == 0 {
                self.pongTimeinterval = Int(Date().timeIntervalSince1970)
            } else {
                let time = Date().timeIntervalSince1970
                if Int(time) - self.pongTimeinterval >= Int(self.heartBeatTimeInterval * 2) {
                    SDKDebugLog("Debug Test Socket ping, but pong wait long time beyond 60s, start reConnect!")
                    self.reConnect()
                    return
                }
            }
            self.sendHeartBeat()
        }
        timer.tolerance = 0.2
        RunLoop.current.add(timer, forMode: .common)
        
        hTimer = timer
    }
    
    private func destoryHeartBeatTimer() {
        
        if let timer = hTimer {
            timer.invalidate()
            hTimer = nil
            SDKDebugLog("Debug Test Socket timer close")
        }
    }
    
    // MARK: - TMMSRWebSocketDelegate
    public func webSocketDidOpen(_ webSocket: IMSRWebSocket!) {
        SDKDebugLog("Debug Test Socket Socket Did Open")
        sendHeartBeat()
        startSendHeartBeatWithTimer()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Socket_Notification_Name_DidOpen), object: nil, userInfo: nil)
    }
    
    public func webSocket(_ webSocket: IMSRWebSocket!, didReceiveMessage message: Any!) {
        SDKDebugLog("Debug Test Socket message: \(String(describing: message))")
        var data = message as? Data
        if let str = message as? String {
            data = str.data(using: .utf8)
        }
        
        if let trueData = data, let dict: [String: Any] = try? JSONSerialization.jsonObject(with: trueData, options: .mutableLeaves) as? [String : Any] {
            
            if let cmd = dict["cmd"] as? String, cmd.contains("offline") {
                SDKDebugLog("Debug Test Socket wearning: the account login at other device! stocke close!")
                closeSocketWithLogOut()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Socket_Notification_Name_ReceiveMessage), object: nil, userInfo: ["value": IMNetError.TOKEN_ERROR.rawValue])
                return
            }
        }
    

        guard let msg = message else {
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Socket_Notification_Name_ReceiveMessage), object: nil, userInfo: ["value": msg])
    }
    
    public func webSocket(_ webSocket: IMSRWebSocket!, didReceivePong pongPayload: Data!) {
        self.pongTimeinterval = Int(Date().timeIntervalSince1970)
        let str = String(data: pongPayload, encoding: .utf8)
        SDKDebugLog("Debug Test Socket pong: \(String(describing: str)), pongTimeinterval update \(String(describing: pongTimeinterval))")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Socket_Notification_Name_Pong), object: nil, userInfo: nil)
    }
    
    public func webSocket(_ webSocket: IMSRWebSocket!, didFailWithError error: Error!) {
        SDKDebugLog("Debug Test Socket error: \(String(describing: error))")
        if let err = error {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Socket_Notification_Name_Fail), object: nil, userInfo: ["value": err])
        }
        guard let socket = socketObj, socket.readyState == IMSRReadyState.OPEN else {
            reConnect()
            return
        }
    }
    
    public func webSocket(_ webSocket: IMSRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        SDKDebugLog("Debug Test Socket close! code: \(code)")
        cleanObj()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Socket_Notification_Name_DidClose), object: nil, userInfo: ["value": code])

        if closeSocketWithUser == false {
            SDKDebugLog("Debug Test Socket closeSocketWithUser is false, socket reConnect!")
            reConnect()
        }
    }
}
