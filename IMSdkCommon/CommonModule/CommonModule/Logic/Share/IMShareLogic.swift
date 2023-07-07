//
//  IMShareLogic.swift
//  TMM
//
//  Created by Joey on 2022/11/19.
//  Copyright © 2022 yinhe. All rights reserved.
//

import UIKit
import WCDBSwift

public class IMShareLogic: NSObject {

    public var shareDB: Database?
    public var context: IMContext?
    public init(_ shareDB: Database?) {
        self.shareDB = shareDB
    }
    
    public init(context: IMContext) {
        self.context = context
        self.shareDB = context.shareDB
    }
    
    
    
}
