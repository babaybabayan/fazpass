//
//  HTTPBody.swift
//  ios-trusted-device
//
//  Created by Binar - Mei on 06/01/23.
//

import Foundation

class Parameters<T: Encodable> {
    var value: Data? {
        guard let value = object else { return nil }
        return try? JSONEncoder().encode(value)
    }
    
    private var object: T?
    
    init(_ value: T) {
        self.object = value
    }
}
