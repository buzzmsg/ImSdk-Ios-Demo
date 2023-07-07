//
//  OssDownLoadStatus.swift
//  CommonModule
//
//  Created by oceanMAC on 2023/5/15.
//

import Foundation

protocol OssDownLoadStatus {
    
    @discardableResult
    func startDownload(objectId: String) -> Promise<OssDownLoadStatus>
    
    @discardableResult
    func grabDownload(objectId: String) -> Promise<OssDownLoadStatus>
    
    @discardableResult
    func pause(objectId: String) -> Promise<OssDownLoadStatus>
    
    @discardableResult
    func delete(objectId: String) -> Promise<OssDownLoadStatus>
    
    @discardableResult
    func failed(objectId: String) -> Promise<OssDownLoadStatus>
    
    @discardableResult
    func overTime(objectId: String) -> Promise<OssDownLoadStatus>
    
    @discardableResult
    func channelGrabbed(objectId: String) -> Promise<OssDownLoadStatus>
    
    @discardableResult
    func success(objectId: String) -> Promise<OssDownLoadStatus>
    
    @discardableResult
    func getDownloadProgress() -> Int
    
    @discardableResult
    func releaseChannel(objectId: String, timeStamp: Int) -> Promise<OssDownLoadStatus>
}

