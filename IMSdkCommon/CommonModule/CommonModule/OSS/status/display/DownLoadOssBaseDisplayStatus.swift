//
//  DownLoadOssBaseDisplayStatus.swift
//  CommonModule
//
//  Created by oceanMAC on 2023/5/15.
//

import Foundation

class DownLoadOssBaseDisplayStatus : NSObject,OssDownLoadDisplayStatus {
    
    func showView(viewStatus: OssDownLoadViewStatus) {
        
    }

    var status:Int = 0

    init(status:Int) {
        self.status = status
    }
}
