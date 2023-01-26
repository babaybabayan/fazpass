//
//  Permission.swift
//  ios-trusted-device
//
//  Created by Binar - Mei on 10/01/23.
//

import UIKit

class Permission {
    
    private var context: FazpassContext
    private var locationManager: LocationManager
    
    init(context: FazpassContext) {
        self.context = context
        self.locationManager = LocationManager()
        self.locationManager.delegate = self
    }
    
    func checkLocationManagerAuthorization() {
        locationManager.checkLocationManagerAuthorization()
    }
    
    func isJailBreak() {
        for tool in Constant.jailbreakTools {
            if UIApplication.shared.canOpenURL(URL(string: tool)!) {
                print("Device is jailbroken")
                break
            }
        }
    }
    
    func isSumulator() {
        if Platform.isSimulator {
            print("Running on a simulator")
        }
    }
}

extension Permission: LocationManagerProtocol {
    func getLocation(location: Location?) {
        context.location = location
    }
}
