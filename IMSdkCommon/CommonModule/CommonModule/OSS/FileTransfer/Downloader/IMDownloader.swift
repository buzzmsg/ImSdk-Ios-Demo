//
//  IMDownloader.swift
//  TMM
//
//  Created by  on 2022/5/17.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation

let kDefaultReferenceCount: Int = 1
public protocol IMDownloader {
    
    func download(objectID: String)
    func cancel(objectId: String, success: @escaping CancleTaskSuccess)
    
    var objectParse: IMImageUrlParse? { get set }
    var ossPath: String { get set }
    var ossContext: IMContext { get set }
    var deleagte: IMOSSDelegate? { get set }
    var oss: IMOSS? { get set }

    func increaseReferenceCount()
    func reduceReferenceCount()
    func getReferenceCount() -> Int
    
}
