//
//  VenuesCellModel.swift
//  NearBy
//
//  Created by Khaled Elshamy on 05/10/2021.
//

import Foundation

import Foundation

// MARK: - AddInquiryModel
struct VenuesCellModel: Codable {
    let meta: Meta?
    let response: Response?
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
    let venues: [Venue]?
    let confident: Bool?
}

// MARK: - Venue
struct Venue: Codable {
    let id, name: String?
    let location: Location?
    let categories: [Category]?
    let referralID: String?
    let hasPerk: Bool?
    let delivery: Delivery?
    let venuePage: VenuePage?

    enum CodingKeys: String, CodingKey {
        case id, name, location, categories
        case referralID = "referralId"
        case hasPerk, delivery, venuePage
    }
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
    let suffix: Suffix?

    enum CodingKeys: String, CodingKey {
        case iconPrefix = "prefix"
        case suffix
    }
}

enum Suffix: String, Codable {
    case png = ".png"
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

// MARK: - VenuePage
struct VenuePage: Codable {
    let id: String?
}
