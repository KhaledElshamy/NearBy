//
//  URLs.swift
//  NearBy
//
//  Created by Khaled Elshamy on 09/10/2021.
//

import Foundation

struct URLs  {
    enum Path {
        case getPlaces(lat:Double,
                       long:Double,
                       radius:Double,
                       currentDate:String,
                       offset:Int,
                       limit:Int)
        
        case getPhoto(placeId:String,
                      currentDate:String)
        
        var absolutePath: String {
            switch self {
            case .getPlaces(let lat, let long, let radius, let currentDate, let offset, let limit):
                return "/venues/explore?radius=\(radius)&ll=\(lat),\(long)&client_id=TEH5P5YCUJULYAJBQM3PD3C0WC1KVKLQINPLNK4EKOTOTGET&client_secret=5GTO4CHYWYACQW24WEDP53Q0CZVSNSVOYNO34RA0DYZ2EYXH&offset=\(offset)&limit=\(limit)&v=\(currentDate)"
                
            case .getPhoto(let placeId, let currentDate):
                return "/venues/\(placeId)/photos?client_id=TEH5P5YCUJULYAJBQM3PD3C0WC1KVKLQINPLNK4EKOTOTGET&client_secret=5GTO4CHYWYACQW24WEDP53Q0CZVSNSVOYNO34RA0DYZ2EYXH&v=\(currentDate)"
            }
        }
    }
}
