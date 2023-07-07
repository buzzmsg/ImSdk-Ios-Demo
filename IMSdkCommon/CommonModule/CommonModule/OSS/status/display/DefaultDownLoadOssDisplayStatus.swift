//
//  DefaultDownLoadOssDisplayStatus.swift
//  CommonModule
//
//  Created by oceanMAC on 2023/5/15.
//

import Foundation

class DefaultDownLoadOssDisplayStatus: DownLoadOssBaseDisplayStatus {
    
    override func showView(viewStatus: OssDownLoadViewStatus) {
        viewStatus.showDefault()
    }
}
