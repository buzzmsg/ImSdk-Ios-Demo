//
//  DownLoadPauseOssDisplayStatus.swift
//  CommonModule
//
//  Created by oceanMAC on 2023/5/15.
//

import Foundation

class DownLoadPauseOssDisplayStatus: DownLoadOssBaseDisplayStatus {
    
    override func showView(viewStatus: OssDownLoadViewStatus) {
        viewStatus.showDownloadPause()
    }
}
