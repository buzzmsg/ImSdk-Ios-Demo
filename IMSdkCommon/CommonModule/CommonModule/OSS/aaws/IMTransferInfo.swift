//
//  IMTransferInfo.swift
//  TMM
//
//  Created by  on 2021/8/12.
//  Copyright © 2021 TMM. All rights reserved.
//

import Foundation


class IMTransferInfo {
    
    var objectId : String = ""
    var progress: Int = 0
    var fileStatus: Int = IMFileTransferStatus.Not_Require
    
    
    
    
    
    
    
    var tranferId: String = "" //TODO
    var bucketId : String = ""
    // order to match upload task
    var filePath : String = ""
    
    required init() {
    
    }
}
