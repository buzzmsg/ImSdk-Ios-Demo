//
//  IMFileUploadProgress.swift
//  TMM
//
//  Created by  on 2022/5/18.
//  Copyright © 2022 yinhe. All rights reserved.
//

import Foundation

@objcMembers class IMFileUploadProgress: NSObject {
    
    
    static public let `shared`: IMFileUploadProgress = {
        let sha: IMFileUploadProgress = IMFileUploadProgress()
        return sha
    }()
    
    
    private var uploadingTask: [String : IMFileProgressModel] = [:]
    
    func initializeUploadDB() {
        
    }
    
    
    //MARK: update
    
    public func updateUploadingProgress(objectId: String, progress: Int) {
        if var task = uploadingTask[objectId] {
            if task.progress > progress {
                return
            }
            task.progress = progress
            uploadingTask.updateValue(task, forKey: objectId)
        }
    }
    
    public func startProgress(objectId: String, progress: Int) {
        if var task = uploadingTask[objectId] {
            task.progress = progress
            uploadingTask.updateValue(task, forKey: objectId)
        }
    }
    
    func updateTask(objectId: String, newTask: IMFileProgressModel) {
        if uploadingTask.keys.contains(objectId) {
            uploadingTask.updateValue(newTask, forKey: objectId)
        }
    }
    
    public func updateUploadFailureProgress(objectId: String) {
        if var task = uploadingTask[objectId] {
            let oldProgress = task.progress
            if oldProgress == IMTransferProgressState.start.rawValue  {
                task.progress = -1
            }else {
                task.progress = Int(-abs(oldProgress))
            }
            uploadingTask.updateValue(task, forKey: objectId)
        }
    }
    
    public func updateProgressBucketID(objectId: String, bucketID: String) {
        if var task = uploadingTask[objectId] {
            task.bucketId = bucketID
            uploadingTask.updateValue(task, forKey: objectId)
        }
    }
    
    //MARK: delete
    
    public func deleteTask(objectId: String) {
        
    }
    
    
    //MARK: add
    
    func addUploadTask(objectID: String, task: IMFileProgressModel) {
        
        guard let uploadProgress = self.uploadingTask[objectID] else {
            
            self.uploadingTask[objectID] = task
            return
        }
        let taskIsUploading: Bool = (uploadProgress.progress < IMTransferProgressState.success.rawValue
                                       && uploadProgress.progress >= IMTransferProgressState.start.rawValue)
        
        if !taskIsUploading {
            updateTask(objectId: objectID, newTask: task)
        }
    }
    
    
    //MARK: read
    
    public func getProgress(objectId: String) -> Int {
        let task = uploadingTask[objectId]
        return task?.progress ?? IMTransferProgressState.wait.rawValue
    }
    
    public func uploadTaskIsEmpty() -> Bool {
        return uploadingTask.count == 0
    }
    
    func getWaitTask(count: Int) -> [IMFileProgressModel] {
        
        let taskArr: [IMFileProgressModel] = uploadingTask.map { $0.value }
        let sortTaskArr: [IMFileProgressModel] = taskArr.sorted{ $0.createTime < $1.createTime }
        
        var newTaskArr: [IMFileProgressModel] = []
        for task in sortTaskArr {
            if task.progress == IMTransferProgressState.wait.rawValue {
                if newTaskArr.count < count {
                    newTaskArr.append(task)
                }
            }
        }
        return newTaskArr
    }
 
    
    public func getProgressBucketID(objectId: String) -> String {
        if let task = uploadingTask[objectId] {
           return task.bucketId
        }
        
        return ""
    }
}






