//
//  OssDownLoadViewStatus.swift
//  CommonModule
//
//  Created by oceanMAC on 2023/5/15.
//

import Foundation

@objc public protocol OssDownLoadViewStatus : NSObjectProtocol {
    
    @objc func showDefault()
    @objc func showDownloading()
    @objc func showDownloadFailed()
    @objc func showDownloadSuccess()
    @objc func showDownloadPause()

}
