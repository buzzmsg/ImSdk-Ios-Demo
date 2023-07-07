//
//  IMFileUploadEvent.swift
//  TMMIMSdk
//
//  Created by oceanMAC on 2022/10/11.
//

import Foundation

@objcMembers public class IMFileUploadEvent : NSObject, IMEvent {
    
    override public init() {
        super.init()
    }
    
    init(objectIds: [String]) {
        self.objectIds = objectIds
    }
    
    private(set) public var objectIds: [String] = []
    
    
    // MARK: -

    public func getData() -> [String] {
        return self.objectIds
    }
    
    public func getName() -> String {
        return NSStringFromClass(Self.self)
    }

}
