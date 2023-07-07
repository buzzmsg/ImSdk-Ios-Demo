//
//  IMThumbUtils.swift
//  TMMIMSdk
//
//  Created by oceanMAC on 2022/10/11.
//

import Foundation

public let THUMB_MIN_WIDTH = 240
public let THUMB_MIN_HEIGHT = 240

@objcMembers public class IMThumbUtils: NSObject {

    private var minWidth: Int = 0
    private var minHeight: Int = 0
    private var maxWidth: Int = 0
    private var maxHeight: Int = 0
    private var bigWidth: Int = 0

    private var momentsImageThumbWidth: Int = 720
    private var momentsImageThumbHeight: Int = 720

    override public init() {
//        minWidth = (TmUtils.sApp.resources.getDimensionPixelSize(R.dimen.dp_120))
//        minHeight = (TmUtils.sApp.resources.getDimensionPixelSize(R.dimen.dp_120))
//        maxHeight = (TmUtils.sApp.resources.getDimensionPixelSize(R.dimen.dp_270))
//        maxWidth = (TmUtils.sApp.resources.getDimensionPixelSize(R.dimen.dp_270))
//        bigWidth = (TmUtils.sApp.resources.getDimensionPixelSize(R.dimen.dp_640))
        minWidth = THUMB_MIN_WIDTH
        minHeight = THUMB_MIN_HEIGHT
        maxHeight = 540
        maxWidth = 540
        bigWidth = 1280
    }

    public func getMomentsImgThumb(reqWidth: Int, reqHeight: Int) -> (Int, Int) {
        minWidth = 720
        minHeight = 720
        maxHeight = 1280
        maxWidth = 1280
        
        return self.getImgThumb(reqWidth: reqWidth, reqHeight: reqHeight)
    }
    
    public func getImgThumb(reqWidth: Int, reqHeight: Int) -> (Int, Int) {
        var requestWidth : Int = 0
        var requestHeight : Int = 0
        var tempWidth : Int = 0
        var tempHeight : Int = 0
        var width = reqWidth
        var height = reqHeight
        if (width == 0) {
            width = maxWidth
        }
        if (height == 0) {
            height = maxHeight
        }

        if (width <= minWidth && height <= minHeight) {
            if (width * 9 <= height * 4) {//1
                requestWidth = minWidth
                tempHeight = height * minWidth / width
                if (tempHeight > maxHeight) {
                    requestHeight = maxHeight
                } else {
                    requestHeight = tempHeight
                }
            } else if (height * 9 <= width * 4) {//4
                requestHeight = minHeight
                tempWidth = width * minHeight / height
                if (tempWidth > maxWidth) {
                    requestWidth = maxWidth
                } else {
                    requestWidth = tempWidth
                }
            } else if (width * 9 > height * 4 && height >= width) {//2
                requestWidth = minWidth
                tempHeight = height * minWidth / width
                if (tempHeight > maxHeight) {
                    requestHeight = maxHeight
                } else {
                    requestHeight = tempHeight
                }
            } else if (height * 9 > width * 4 && height < width) {//3
                requestHeight = minHeight
                tempWidth = width * minHeight / height
                if (tempWidth > maxWidth) {
                    requestWidth = maxWidth
                } else {
                    requestWidth = tempWidth
                }
            }
        } else if (minWidth < width && width < maxWidth && height <= minHeight) {
            if (height * 9 <= width * 4) {//5
                requestHeight = minHeight
                tempWidth = width * minHeight / height
                if (tempWidth > maxWidth) {
                    requestWidth = maxWidth
                } else {
                    requestWidth = tempWidth
                }
            } else {//6
                requestHeight = minHeight
                tempWidth = width * minHeight / height
                if (tempWidth > maxWidth) {
                    requestWidth = maxWidth
                } else {
                    requestWidth = tempWidth
                }
            }
        } else if (minHeight < height && height < maxHeight && width <= minWidth) {
            if (width * 9 <= height * 4) {//10
                requestWidth = minWidth
                tempHeight = height * minWidth / width
                if (tempHeight > maxHeight) {
                    requestHeight = maxHeight
                } else {
                    requestHeight = tempHeight
                }
            } else {//9
                requestWidth = minWidth
                tempHeight = height * minWidth / width
                if (tempHeight > maxHeight) {
                    requestHeight = maxHeight
                } else {
                    requestHeight = tempHeight
                }
            }
        } else if (minWidth <= width && width <= maxWidth && (minHeight <= height && height <= maxHeight)) {//7/8
            requestWidth = width
            requestHeight = height
        } else if (width <= minWidth && height >= maxHeight) {//11
            requestWidth = minWidth
            requestHeight = maxHeight
        } else if (height <= minHeight && width >= maxWidth) {//18
            requestHeight = minHeight
            requestWidth = maxWidth
        } else if (width > minWidth && width < maxWidth && height > maxHeight && width * 9 <= height * 4) {//12
            requestWidth = minWidth
            tempHeight = height * minWidth / width
            if (tempHeight > maxHeight) {
                requestHeight = maxHeight
            } else {
                requestHeight = tempHeight
            }
        } else if (height > minHeight && height < maxHeight && width > maxWidth && height * 9 <= width * 4) {//17
            requestHeight = minHeight
            tempWidth = width * minHeight / height
            if (tempWidth > maxWidth) {
                requestWidth = maxWidth
            } else {
                requestWidth = tempWidth
            }
        } else if (minWidth < width && width < maxWidth && height > maxHeight) {//13
            requestHeight = maxHeight
            tempWidth = width * maxHeight / height
            if (tempWidth > maxWidth) {
                requestWidth = maxWidth
            } else {
                requestWidth = tempWidth
            }
        }else if (minHeight < height && height < maxHeight && width > maxWidth) {//16
            requestWidth = maxWidth
            tempHeight = height * maxWidth / width
            if (tempHeight > maxHeight) {
                requestHeight = maxHeight
            } else {
                requestHeight = tempHeight
            }
        }else if (width >= maxWidth && height >= maxHeight && height >= width){//14
            requestHeight = maxHeight
            tempWidth = width * maxHeight / height
            if (tempWidth > maxWidth) {
                requestWidth = maxWidth
            } else {
                requestWidth = tempWidth
            }
        }else if (width >= maxWidth && height >= maxHeight && width >= height){//15
            requestWidth = maxWidth
            tempHeight = height * maxWidth / width
            if (tempHeight > maxHeight) {
                requestHeight = maxHeight
            } else {
                requestHeight = tempHeight
            }
        }

        if (requestWidth < minWidth && requestHeight == maxHeight) {
            requestWidth = minWidth
            requestHeight = maxHeight
        }

        if (requestHeight < minHeight && requestWidth == maxWidth){
            requestWidth = maxWidth
            requestHeight = minHeight
        }
        
        
        return (requestWidth, requestHeight)
    }

    public func getBigImgThumb(reqWidth: Int, reqHeight: Int) -> (Int, Int) {
        var requestWidth:  Int = 0
        var requestHeight : Int = 0

        if reqWidth > bigWidth && reqHeight > bigWidth {
            if reqWidth > reqHeight {
                requestHeight = bigWidth
                requestWidth = reqWidth * bigWidth / reqHeight
            }else {
                requestWidth = bigWidth
                requestHeight = reqHeight * bigWidth / reqWidth
            }
            
        }else {
            requestWidth = reqWidth
            requestHeight = reqHeight
        }
        
        return (requestWidth, requestHeight)

        
        
        

        var width = reqWidth
        var height = reqHeight
        if (width == 0) {
            width = bigWidth
        }
        if (height == 0) {
            height = bigWidth
        }
        if (width > bigWidth) {
            if (height > bigWidth) {
                if (height > width) {
                    if ((height / width) > 2 || ((height / width) == 2 && (height % width) > 0)) {
                        requestWidth = bigWidth
                        requestHeight = height * bigWidth / width
                    } else {
                        requestHeight = bigWidth
                        requestWidth = width * bigWidth / height
                    }
                } else {
                    if ((width / height) > 2 || ((width / height) == 2 && (width % height) > 0)) {
                        requestHeight = bigWidth
                        requestWidth = width * bigWidth / height
                    } else {
                        requestWidth = bigWidth
                        requestHeight = height * bigWidth / width
                    }
                }
            } else {//height <= bigWidth
                if ((width / height) > 2 || ((width / height) == 2 && (width % height) > 0)) {
                    requestHeight = height
                    requestWidth = width
                } else {
                    requestWidth = bigWidth
                    requestHeight = height * bigWidth / width
                }
            }
        } else {//width <= bigWidth
            if (height > bigWidth) {
                if ((height / width) > 2 || ((height / width) == 2 && (height % width) > 0)) {
                    requestHeight = height
                    requestWidth = width
                } else {
                    requestHeight = bigWidth
                    requestWidth = width * bigWidth / height
                }
            } else {//height <= bigWidth
                requestHeight = height
                requestWidth = width
            }
        }
        return (requestWidth, requestHeight)
    }
    
    public func getAvatarThumb(reqWidth: Int, reqHeight: Int) -> (Int, Int)  {
        let requestWidth = THUMB_AVATAR_WIDTH
        let requestHeight = THUMB_AVATAR_HEIGHT

        return (requestWidth, requestHeight)
    }
    
    // MARK: - Moments
    public func getMomentsImageThumb(reqWidth: Int, reqHeight: Int) -> (Int, Int)  {
        return (momentsImageThumbWidth, momentsImageThumbHeight)
    }
    
    public func getMomentsBigImgThumb(reqWidth: Int, reqHeight: Int) -> (Int, Int) {
        return self.getBigImgThumb(reqWidth: reqWidth, reqHeight: reqHeight)
    }
}
public let THUMB_AVATAR_WIDTH = 240
public let THUMB_AVATAR_HEIGHT = 240
