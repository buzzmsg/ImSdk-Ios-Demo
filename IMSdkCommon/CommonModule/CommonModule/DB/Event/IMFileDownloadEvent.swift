//
//  IMFileDownloadEvent.swift
//  TMMIMSdk
//
//  Created by oceanMAC on 2022/10/11.
//

import ObjectiveC

@objcMembers public class IMFileDownloadEvent : NSObject, IMEvent {
    
    public func getData() -> [String] {
        return self.objectIds
    }
    
    public func getName() -> String {
        return "file_download_event"
    }
    

    // MARK: - New

    public var objectIds: [String] = []

}
