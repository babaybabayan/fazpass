//
//  User.swift
//  ios-trusted-device
//
//  Created by Binar - Mei on 12/01/23.
//

import Foundation

public struct User: Codable {
    var pin, app, device, userId: String?
    public init(pin: String? = nil, app: String? = nil, device: String? = nil, userId: String? = nil) {
        self.pin = pin
        self.app = app
        self.device = device
        self.userId = userId
    }
}
