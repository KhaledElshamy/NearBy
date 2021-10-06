//
//  LocationService.swift
//  NearBy
//
//  Created by Khaled Elshamy on 05/10/2021.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay

final class LocationService: NSObject {
    
    static let shared: LocationService = LocationService()
    private let manager = CLLocationManager()
    private let userDefault = UserDefaults()
    
    private let currentLocationRelay: BehaviorRelay<(lat:Double, long:Double)?> = BehaviorRelay(value: nil)
    lazy var currentLocation: Observable<(lat:Double, long:Double)?> = self.currentLocationRelay.asObservable().share(replay: 1, scope: .forever)
    private var lastLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    
    private override init(){
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager(){
        
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            manager.startUpdatingLocation()
            manager.allowsBackgroundLocationUpdates = true
        }
    }
}


extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            let currentLocation = (
                lat: location.coordinate.latitude,
                long: location.coordinate.longitude
            )
            
            if lastLocation.coordinate.latitude == 0.0 && lastLocation.coordinate.longitude == 0.0 {
                lastLocation = location
                currentLocationRelay.accept(currentLocation)
            }else {
                let distanceInMeters = location.distance(from: lastLocation)
                if distanceInMeters > 500 && !userDefault.bool(forKey: "singleUpdate") {
                    currentLocationRelay.accept(currentLocation)
                }
            }
        }
    }
}
