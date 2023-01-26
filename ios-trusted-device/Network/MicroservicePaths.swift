//
//  MicroservicePaths.swift
//  ios-trusted-device
//
//  Created by Binar - Mei on 09/01/23.
//

import Foundation

enum MicroservicePaths {
    case postCheck
    case postEnroll
    case postVerify
    case postRemove
    case postNotification
    case postConfirmStatus
    case postValidatePin
    case postOtpSend
    case postOtpGenerate
    case postOtpRequest
    case postWABlasting
    case postSMSlasting
    case postCallbackMotp
    case putLastUpdateDevice
    case putUpdateExpired
    case putUpdateNotificationToken
    case getAuthPage
}

extension MicroservicePaths {
    var method: String {
        switch self {
        case .putLastUpdateDevice, .putUpdateExpired, .putUpdateNotificationToken:
            return "PUT"
        default:
            return "POST"
        }
    }
    var path: String {
        switch self {
        case .postCheck:
            return Constant.version + Constant.applicationContext + "check"
        case .postEnroll:
            return Constant.version + Constant.applicationContext + "enroll"
        case .postVerify:
            return Constant.version + "otp/verify"
        case .postRemove:
            return Constant.version + Constant.applicationContext + "remove"
        case .postNotification:
            return Constant.version + Constant.applicationContext + "notification"
        case .postConfirmStatus:
            return Constant.version + Constant.applicationContext + "confirmation/status"
        case .postValidatePin:
            return Constant.version + Constant.applicationContext + "validate/pin"
        case .postOtpSend:
            return Constant.version + "otp/send"
        case .postOtpGenerate:
            return Constant.version + "otp/generate"
        case .postOtpRequest:
            return Constant.version + "otp/request"
        case .postWABlasting:
            return Constant.version + "message/send"
        case .postSMSlasting:
            return Constant.version + "callback/citcall/motp"
        case .postCallbackMotp:
            return Constant.version + "callback/citcall/smsotp"
        case .putLastUpdateDevice:
            return Constant.version + Constant.applicationContext + "update/last-active"
        case .putUpdateExpired:
            return Constant.version + Constant.applicationContext + "update/expired"
        case .putUpdateNotificationToken:
            return Constant.version + Constant.applicationContext + "update/notification-token"
        case .getAuthPage:
            return Constant.version + "he/request/auth-page"
        }
    }
}
