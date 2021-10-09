//
//  VenueExtension.swift
//  NearBy
//
//  Created by Khaled Elshamy on 07/10/2021.
//

import Foundation

// For test 
extension Venue {
    static func with(id:String = "42377700f964a52024201fe3",
                     name:String = "Brooklyn Heights Promenade")-> Venue
    {
        return Venue(id: id, name: name, location: nil, categories: nil, photos: nil, delivery: nil, venuePage: nil)
    }
}
