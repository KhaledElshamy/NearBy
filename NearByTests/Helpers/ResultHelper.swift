//
//  ResultHelper.swift
//  NearByTests
//
//  Created by Khaled Elshamy on 07/10/2021.
//

import Foundation

enum Result<T, U: Error> {
    case success(payload: T)
    case failure(U?)
}
