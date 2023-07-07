//
//  IMDownloadChannel.swift
//  CommonModule
//
//  Created by Joey on 2023/5/15.
//

import Foundation



protocol IMDownloadChannel {
    
//    func next() -> Promise<Void>
    func next()
    func setOss(oss: IMOSS)
    func channelMaybeIdle() -> Bool
//    @discardableResult
//    func channelMaybeIdle() -> Promise<Bool>
    func channelMaybeContain(objectId: String) -> Bool
    func cancelDownloadingBigFileOnNetChange()
    func clearAllChannel()
    
    func grab(prog: IMFileProgressModel)
    func into(prog: IMFileProgressModel)
    func channelMaybeContainSmallFile() -> Bool
    
    func success(objectIds: [String])
    func cancel(objectIds: [String])
    func wait(objectIds: [String])
    func pause(objectId: String)
}
