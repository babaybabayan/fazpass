//
//  Extensions.swift
//  ios-trusted-device
//
//  Created by Binar - Mei on 12/01/23.
//

import Foundation

extension Result where Success == Void {
    public static var success: Result { .success(()) }
}

public enum Results<Success, Incoming, Failure> {
    case success(Success)
    case incomingMessage(Incoming)
    case failure(Failure)
}
