//
//  IMUploader.swift
//  TMM
//
//  Created by  on 2022/5/17.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation

@objc protocol IMUploader {

    func upload(objectID: String)
    func cancel(objectID: String, success: @escaping CancleTaskSuccess)
    
    var bucketId: String { get set }
    var ossContext: IMContext { get set }
    var ossPath: String { get  set }
    var uploadProgress: IMFileUploadProgress { get set }
    
}
