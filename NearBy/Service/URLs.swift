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
                return "/venues/explore?radius=\(radius)&ll=\(lat),\(long)&client_id=I5IVAR3XPPXRPTODR3NQYGNEE0IRKC2M3TRXQTGTA2ZEWMWW&client_secret=FU4E2ICP10ELXNNKCV4UHG0JFWJBY125DEVQ3QKJOGDWMT0W&offset=\(offset)&limit=\(limit)&v=\(currentDate)"
                
            case .getPhoto(let placeId, let currentDate):
                return "/venues/\(placeId)/photos?client_id=I5IVAR3XPPXRPTODR3NQYGNEE0IRKC2M3TRXQTGTA2ZEWMWW&client_secret=FU4E2ICP10ELXNNKCV4UHG0JFWJBY125DEVQ3QKJOGDWMT0W&v=\(currentDate)"
            }
        }
    }
}
