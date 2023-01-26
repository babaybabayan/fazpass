//
//  Responses.swift
//  ios-trusted-device
//
//  Created by Binar - Mei on 02/01/23.
//

import Foundation

public struct ApiResponse<C: Codable>: Codable {
    let status: Bool?
    let message, code: String?
    let data: C?
}

// MARK: - DataClass
public struct CheckResponse: Codable {
    let user: UserResponse?
    let apps: Apps?
}

// MARK: - Apps
public struct Apps: Codable {
    let current: Current?
    let others: [Other]?
    let crossApp: Bool?
    enum CodingKeys: String, CodingKey {
        case current, others
        case crossApp = "cross_app"
    }
}

// MARK: - Current
public struct Current: Codable {
    let meta, key: String?
    let isTrusted, useFingerprint, usePin: Bool?
    enum CodingKeys: String, CodingKey {
        case meta, key
        case isTrusted = "is_trusted"
        case useFingerprint = "use_fingerprint"
        case usePin = "use_pin"
    }
}

public struct Other: Codable {
    let app, device: String?
    let isTrusted, useFingerprint, usePin: Bool?

    enum CodingKeys: String, CodingKey {
        case app, device
        case isTrusted = "is_trusted"
        case useFingerprint = "use_fingerprint"
        case usePin = "use_pin"
    }
}

// MARK: - User
public struct UserResponse: Codable {
    let id: String?
}

public struct OtpResponse: Codable {
    let id, otp: String?
    let otpLength: Int?
    let channel, provider, purpose: String?

    enum CodingKeys: String, CodingKey {
        case id, otp
        case otpLength = "otp_length"
        case channel, provider, purpose
    }
}
