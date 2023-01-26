//
//  ErrorResponse.swift
//  ios-trusted-device
//
//  Created by Binar - Mei on 22/01/23.
//

import Foundation

public enum FazPassError: Error {
    case notFound // 404
    case badGateWay // 502
    case internalServerError
    case decodeError
    case generalError
    case phoneOrEmailEmpty
    case softError(error: ErrorResponse)
    
    public var message: String {
        switch self {
        case .notFound:
            return "Not Found"
        case .badGateWay:
            return "Bad Gateway"
        case .internalServerError:
            return "Internal Server Error"
        case .decodeError:
            return "Object Failed to Decode"
        case .generalError:
            return "Something Went Wrong!"
        case .phoneOrEmailEmpty:
            return "Email or phone number cannot be null!"
        case .softError(error: let error):
            return error.message
        }
    }
    
    public var softErrorResponse: ErrorResponse {
        switch self {
        case .softError(let errorResponse):
            return errorResponse
        default:
            return ErrorResponse.init(code: "", status: false, message: "")
        }
    }
}

public struct ErrorResponse: Codable, Error {
    public var code: String
    public var status: Bool
    public var message: String
    
    public init(code: String, status: Bool, message: String) {
        self.code = code
        self.status = status
        self.message = message
    }
}
