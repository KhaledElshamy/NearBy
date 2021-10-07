//
//  ApiClient.swift
//  NearBy
//
//  Created by Khaled Elshamy on 05/10/2021.
//

import Alamofire
import RxSwift

enum GetPlacesFailureReason: Int, Error {
    case notFound = 404
}

class ApiClient {
    
    // MARK: - get nearby places
    func getNearbyPlaces(lat:Double,
                         long:Double,
                         radius:Double,
                         currentDate:String) -> Observable<VenuesModel>
    {
        
        return Observable.create { (observer) -> Disposable in
            let url = ConfigurationManager.BaseURL + "/venues/explore?radius=\(radius)&ll=\(lat),\(long)&client_id=I5IVAR3XPPXRPTODR3NQYGNEE0IRKC2M3TRXQTGTA2ZEWMWW&client_secret=FU4E2ICP10ELXNNKCV4UHG0JFWJBY125DEVQ3QKJOGDWMT0W&v=\(currentDate)"
            
            Alamofire.request(url,method: .get)
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error!)
                            return
                        }
                        do {
                            let result = try JSONDecoder().decode(VenuesModel.self, from: data)
                            observer.onNext(result)
                        }catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                        return
                    }
                }
            return Disposables.create()
        }
    }
    
    
    // MARK: - get image of place
    func getPlaceImage (placeId:String,
                        currentDate:String) -> Observable<PhotoServiceModel>
    {
        
        return Observable.create { (observer) -> Disposable in
            let url = ConfigurationManager.BaseURL + "/venues/\(placeId)/photos?client_id=I5IVAR3XPPXRPTODR3NQYGNEE0IRKC2M3TRXQTGTA2ZEWMWW&client_secret=FU4E2ICP10ELXNNKCV4UHG0JFWJBY125DEVQ3QKJOGDWMT0W&v=\(currentDate)"
            
            Alamofire.request(url,method: .get)
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error!)
                            return
                        }
                        do {
                            let result = try JSONDecoder().decode(PhotoServiceModel.self, from: data)
                            observer.onNext(result)
                        }catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                        return
                    }
                }
            return Disposables.create()
        }
    }
}
