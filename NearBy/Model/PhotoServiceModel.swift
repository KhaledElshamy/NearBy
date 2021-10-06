//
//  PhotoModel.swift
//  NearBy
//
//  Created by Khaled Elshamy on 06/10/2021.
//

import Foundation

// MARK: - AddInquiryModel
struct PhotoServiceModel: Codable {
    let meta: PhotoMeta?
    let response: PhotoResponse?
}

// MARK: - Meta
struct PhotoMeta: Codable {
    let code: Int?
    let requestID: String?

    enum CodingKeys: String, CodingKey {
        case code
        case requestID = "requestId"
    }
}

// MARK: - Response
struct PhotoResponse: Codable {
    let photos: PlacePhotos?
}

// MARK: - Photos
struct PlacePhotos: Codable {
    let count: Int?
    let items: [Item]?
    let dupesRemoved: Int?
}

// MARK: - Item
struct Item: Codable {
    let id: String?
    let createdAt: Int?
    let source: Source?
    let itemPrefix: String?
    let suffix: String?
    let width, height: Int?
    let checkin: Checkin?
    let visibility: String?

    enum CodingKeys: String, CodingKey {
        case id, createdAt, source
        case itemPrefix = "prefix"
        case suffix, width, height, checkin, visibility
    }
}

// MARK: - Checkin
struct Checkin: Codable {
    let id: String?
    let createdAt: Int?
    let type: String?
    let timeZoneOffset: Int?
}

// MARK: - Source
struct Source: Codable {
    let name: String?
    let url: String?
}
