//
//  VenuesCellModel.swift
//  NearBy
//
//  Created by Khaled Elshamy on 05/10/2021.
//

import Foundation

struct VenuesModel: Codable {
    let meta: Meta?
    let response: Response?
    
    func compactMap() -> [PlacesTableViewCellType] {
        return response?.groups?[0].items?.compactMap {
            .normal(cellViewModel: PlacesCellModel(name: $0.venue?.name, id: $0.venue?.id, address: $0.venue?.location?.address, imageUrl: nil))
        } ?? [] 
    }
}

// MARK: - Meta
struct Meta: Codable {
    let code: Int?
    let requestID: String?

    enum CodingKeys: String, CodingKey {
        case code
        case requestID = "requestId"
    }
}

// MARK: - Response
struct Response: Codable {
    let suggestedFilters: SuggestedFilters?
    let headerLocation, headerFullLocation: String?
    let headerLocationGranularity: String?
    let totalResults: Int?
    let suggestedBounds: SuggestedBounds?
    let groups: [Group]?
}

// MARK: - Group
struct Group: Codable {
    let type, name: String?
    let items: [GroupItem]?
}

// MARK: - GroupItem
struct GroupItem: Codable {
    let reasons: Reasons?
    let venue: Venue?
    let referralID: String?

    enum CodingKeys: String, CodingKey {
        case reasons, venue
        case referralID = "referralId"
    }
}

// MARK: - Reasons
struct Reasons: Codable {
    let count: Int?
    let items: [ReasonsItem]?
}

// MARK: - ReasonsItem
struct ReasonsItem: Codable {
    let summary: String?
    let type: String?
    let reasonName: String?
}

// MARK: - Venue
struct Venue: Codable {
    let id, name: String?
    let location: Location?
    let categories: [Category]?
    let photos: Photos?
    let delivery: Delivery?
    let venuePage: VenuePage?
}

// MARK: - Category
struct Category: Codable {
    let id, name, pluralName, shortName: String?
    let icon: CategoryIcon?
    let primary: Bool?
}

// MARK: - CategoryIcon
struct CategoryIcon: Codable {
    let iconPrefix: String?
    let suffix: String?

    enum CodingKeys: String, CodingKey {
        case iconPrefix = "prefix"
        case suffix
    }
}


// MARK: - Delivery
struct Delivery: Codable {
    let id: String?
    let url: String?
    let provider: Provider?
}

// MARK: - Provider
struct Provider: Codable {
    let name: String?
    let icon: ProviderIcon?
}

// MARK: - ProviderIcon
struct ProviderIcon: Codable {
    let iconPrefix: String?
    let sizes: [Int]?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case iconPrefix = "prefix"
        case sizes, name
    }
}

// MARK: - Location
struct Location: Codable {
    let address, crossStreet: String?
    let lat, lng: Double?
    let labeledLatLngs: [LabeledLatLng]?
    let distance: Int?
    let postalCode: String?
    let cc: String?
    let city: String?
    let state: String?
    let country: String?
    let formattedAddress: [String]?
    let neighborhood: String?
}

// MARK: - LabeledLatLng
struct LabeledLatLng: Codable {
    let label: String?
    let lat, lng: Double?
}


// MARK: - Photos
struct Photos: Codable {
    let count: Int?
}

// MARK: - VenuePage
struct VenuePage: Codable {
    let id: String?
}

// MARK: - SuggestedBounds
struct SuggestedBounds: Codable {
    let ne, sw: Ne?
}

// MARK: - Ne
struct Ne: Codable {
    let lat, lng: Double?
}

// MARK: - SuggestedFilters
struct SuggestedFilters: Codable {
    let header: String?
    let filters: [Filter]?
}

// MARK: - Filter
struct Filter: Codable {
    let name, key: String?
}
