//
//  Utilities.swift
//  ios-trusted-device
//
//  Created by Binar - Mei on 18/01/23.
//

import Foundation

internal struct Utilities {
    static func debug(_ responseData: Data) {
        let mantap = JSON(responseData)
        print(mantap)
    }
}
