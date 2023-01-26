//
//  LocationManage.swift
//  ios-trusted-device
//
//  Created by Binar - Mei on 10/01/23.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol {
    func getLocation(location: Location?)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var manager: CLLocationManager?
    var delegate: LocationManagerProtocol?
    
    override init() {
        super.init()
        manager = CLLocationManager()
        setupLocationManager()
        checkLocationManagerAuthorization()
    }
    
    private func authorizationStatus() -> CLAuthorizationStatus {
        var status: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            status = CLLocationManager().authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        return status
    }
    
    private func checkLocationService() {
        DispatchQueue.global(qos: .background).async {
            if CLLocationManager.locationServicesEnabled() {
                self.setupLocationManager()
                self.checkLocationManagerAuthorization()
            } else {
                print("Checklocation Error")
            }
        }
    }
    
    private func setupLocationManager() {
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationManagerAuthorization() {
        switch authorizationStatus() {
        case .notDetermined:
            manager?.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            manager?.startUpdatingLocation()
        case .denied, .restricted:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last
        let latitude = currentLocation?.coordinate.latitude ?? 0.0
        let longitude = currentLocation?.coordinate.longitude ?? 0.0
        let location = Location(lat: String(latitude), lng: String(longitude))
        self.delegate?.getLocation(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationService()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}
