//
//  Requests.swift
//  ios-trusted-device
//
//  Created by Binar - Mei on 02/01/23.
//

import Foundation

// MARK: - CheckRequest
public struct CheckRequest: Codable {
    var app, device, email: String?
    var location: Location?
    var phone, timezone: String?
    var user_id: String?
    public init(app: String? = nil, device: String? = nil, email: String? = nil, location: Location? = nil, phone: String? = nil, timezone: String? = nil, userId: String? = nil) {
        self.app = app
        self.device = device
        self.email = email
        self.location = location
        self.phone = phone
        self.timezone = timezone
        self.user_id = userId
    }
}

// MARK: - Enroll
struct Enroll: Codable {
    let address: String?
    let contactCount: Int?
    let device, email, ktp, key: String?
    let location: Location?
    let meta, name, notificationToken, app: String?
    let phone, pin: String?
    let sim: [Sim]?
    let timeZone: String?
    let isTrusted, useFingerprint, usePin, isVPN: Bool?

    enum CodingKeys: String, CodingKey {
        case address
        case contactCount = "contact_count"
        case device, email, ktp, key, location, meta, name
        case notificationToken = "notification_token"
        case app, phone, pin, sim
        case timeZone = "time_zone"
        case isTrusted = "is_trusted"
        case useFingerprint = "use_fingerprint"
        case usePin = "use_pin"
        case isVPN = "is_vpn"
    }
}

// MARK: - Sim
struct Sim: Codable {
    let phone, serial: String?
}

// MARK: - Location
public struct Location: Codable {
    var lat, lng: String?
}
