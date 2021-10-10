//
//  PhotoEndPoint.swift
//  NearBy
//
//  Created by Khaled Elshamy on 09/10/2021.
//

import Foundation


struct PhotosEndPoint: EndPointType {
    
    typealias ResponseModel = PhotoServiceModel
    var path: URLs.Path
    var httpMethod: HTTPMethod? = .get
    var headers: HTTPHeaders?
    var bodyParams: Parameters?
    var queryParams: Parameters?
    var bodyParamsArrayList: [Parameters]?
}

class PhotosNetworkManager {
    private var photosEndPoint: PhotosEndPoint?
    private var photosNetworkRouter: NetworkRouter<PhotosEndPoint>?
    
    func configure(placeId:String,
                   currentDate:String) {
        
        photosEndPoint = PhotosEndPoint(path: .getPhoto(placeId:placeId,
                                                       currentDate:currentDate))
        photosNetworkRouter = NetworkRouter(route:photosEndPoint!)
    }
    
    func request(completion: ((Result<PhotosEndPoint.ResponseModel, Error>) -> Void)?) {
        photosNetworkRouter?.request(completion: completion) 
    }
}
