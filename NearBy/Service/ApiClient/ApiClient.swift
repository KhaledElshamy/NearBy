//
//  ApiClient.swift
//  NearBy
//
//  Created by Khaled Elshamy on 05/10/2021.
//

import RxSwift

enum GetFailureReason: Int, Error {
    case notFound = 404
}

class ApiClient {
    
    private var placesNetworkManager = PlacesNetworkManager()
    
    // MARK: - get nearby places
    func getNearbyPlaces(lat:Double,
                         long:Double,
                         radius:Double,
                         currentDate:String,
                         offset:Int,
                         limit:Int) -> Observable<VenuesModel>
    {
        
        return Observable.create { [weak self] (observer) -> Disposable in
            
            self?.placesNetworkManager.configure(lat: lat,
                                           long: long,
                                           radius: radius,
                                           currentDate: currentDate,
                                           offset: offset,
                                           limit: limit)
            
            self?.placesNetworkManager.request(completion: { (res) in
                switch res {
                case .success(let data):
                    guard let data = data else {
                        observer.onError(GetFailureReason.notFound)
                        return
                    }
                    observer.onNext(data)
                    return
                case .failure(let error):
                    observer.onError(error)
                    return
                }
            })
            return Disposables.create()
        }
    }
    
    
    // MARK: - get image of place
    private var photoNetworkManager = PhotosNetworkManager()
    
    func getPlaceImage (placeId:String,
                        currentDate:String) -> Observable<PhotoServiceModel>
    {
        
        return Observable.create { [weak self] (observer) -> Disposable in
            
            self?.photoNetworkManager.configure(placeId: placeId, currentDate: currentDate)
            self?.photoNetworkManager.request(completion: { (res) in
                switch res {
                case .success(let data):
                    guard let data = data else {
                        observer.onError(GetFailureReason.notFound)
                        return
                    }
                    observer.onNext(data) 
                    return
                case .failure(let error):
                    observer.onError(error)
                    return
                }
            })
            return Disposables.create()
        }
    }
}
