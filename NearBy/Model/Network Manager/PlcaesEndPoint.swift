//
//  PlcaesEndPoint.swift
//  NearBy
//
//  Created by Khaled Elshamy on 09/10/2021.
//

import Foundation

struct PlacesEndPoint: EndPointType {
    
    typealias ResponseModel = VenuesModel
    var path: URLs.Path
    var httpMethod: HTTPMethod? = .get
    var headers: HTTPHeaders?
    var bodyParams: Parameters?
    var queryParams: Parameters?
    var bodyParamsArrayList: [Parameters]?
}

class PlacesNetworkManager {
    private var placesEndPoint: PlacesEndPoint?
    private var placesNetworkRouter: NetworkRouter<PlacesEndPoint>?
    
    func configure(lat:Double,
                   long:Double,
                   radius:Double,
                   currentDate:String,
                   offset:Int,
                   limit:Int) {
        
        placesEndPoint = PlacesEndPoint(path:.getPlaces(lat:lat,
                                                        long:long,
                                                        radius:radius,
                                                        currentDate:currentDate,
                                                        offset:offset,
                                                        limit:limit))
        placesNetworkRouter = NetworkRouter(route:placesEndPoint!)
    }
    
    func request(completion: ((Result<PlacesEndPoint.ResponseModel, Error>) -> Void)?) {
        placesNetworkRouter?.request(completion: completion)
    }
}
