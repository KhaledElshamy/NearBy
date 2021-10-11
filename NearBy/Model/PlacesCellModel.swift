//
//  PlacesCellModel.swift
//  NearBy
//
//  Created by Khaled Elshamy on 05/10/2021.
//

import Foundation


struct PlacesCellModel: Equatable {
    let name:String?
    let id:String?
    let address:String?
    var imageUrl:String?
    
    static func == (lhs: PlacesCellModel, rhs: PlacesCellModel) -> Bool {
        return ( lhs.name == rhs.name &&
                    lhs.id == rhs.id &&
                    lhs.address == rhs.address &&
                    lhs.imageUrl == rhs.imageUrl )
    }
}
