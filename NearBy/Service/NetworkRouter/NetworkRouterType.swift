//
//  NetworkRouterType.swift
//  NearBy
//
//  Created by Khaled Elshamy on 09/10/2021.
//

import Foundation

import Foundation

protocol NetworkRouterType: class {
    associatedtype EndPoint: EndPointType
    
    func request(completion: ((Result<EndPoint.ResponseModel, Error>) -> Void)?)
}
