//
//  TMNetError.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/26.
//

import Foundation

public enum TMNetError : Int {
    case NO_NETWORKING = -1009
    case NETWORKING_TIME_OUT = -1001

    case TOKEN_ERROR = 401
    case COMMON_ERROR = 501
    
    // message single
    case RELATION_DELETE_ME = 100000
    case RELATION_DELETE_OTHER = 100001
    case RELATION_DELETE_BOTH = 100002
    
    // message group
    case GROUP_NOT_IN = 100010
    
    case MOMENT_COMMENT_ERROR_WITH_DELETE = 100006

    case SERVER_DB_ERROR = 400
    case SERVER_COMMON_ERROR = 500
    
    // block user
    case RELATION_BLOCK_BY_ME = 100021
    case RELATION_BLOCK_BY_USER = 100022
    case RELATION_BLOCK_EACH_OTHER = 100023
    
    //delete account
    case DELETE_ACCOUNT = 100011

}
