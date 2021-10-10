//
//  EndPointType.swift
//  NearBy
//
//  Created by Khaled Elshamy on 09/10/2021.
//

import Foundation

public typealias HTTPHeaders = [String:String]
public typealias Parameters = [String:Any]

protocol EndPointType {
    associatedtype ResponseModel: Codable
    var baseURL: URL? { get }
    var path: URLs.Path { get } 
    var httpMethod: HTTPMethod? { get }
    var headers: HTTPHeaders? { get }
    var bodyParams: Parameters? { get }
    var bodyParamsArrayList: [Parameters]? { get }
    var queryParams: Parameters? { get }
}

extension EndPointType {
    var baseURL: URL? {
        guard let url = URL(string: ConfigurationManager.BaseURL) else { return nil }
        return url
    }
}

