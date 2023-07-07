//
//  OssDownLoadDisplayStatus.swift
//  CommonModule
//
//  Created by oceanMAC on 2023/5/15.
//

import Foundation

@objc public protocol OssDownLoadDisplayStatus : NSObjectProtocol {
    
    func showView(viewStatus: OssDownLoadViewStatus)
}
