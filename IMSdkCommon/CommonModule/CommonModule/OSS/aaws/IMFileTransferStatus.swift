//
//  IMFileTransferStatus.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/27.
//

import Foundation

public struct IMFileTransferStatus {
    static public let Download_Success = 1
    static public let Download_Failed = 2
    static public let Downloading = 5
    static public let Uploading = 6
    static public let Uploading_Success = 7
    static public let Uploading_Failed = 8
    static public let Downloading_NoKey = 404

    
    
    static public let Download_Illegal = 3
    static public let Not_Require = 4

}
