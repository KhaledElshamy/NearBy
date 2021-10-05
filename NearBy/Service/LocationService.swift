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
    
    private let currentLocationRelay: BehaviorRelay<(lat:Double, long:Double)?> = BehaviorRelay(value: nil)
    private lazy var currentLocation: Observable<(lat:Double, long:Double)?> = self.currentLocationRelay.asObservable().share(replay: 1, scope: .forever)
    
    private override init(){
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager(){
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.stopUpdatingLocation()
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
            currentLocationRelay.accept(currentLocation)
            manager.stopUpdatingLocation()
        }
    }
}
