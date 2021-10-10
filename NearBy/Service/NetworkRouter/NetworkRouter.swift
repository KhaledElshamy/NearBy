//
//  NetworkRouter.swift
//  NearBy
//
//  Created by Khaled Elshamy on 09/10/2021.
//

import Foundation

enum Result<T:Decodable,Error> {
    case success(T?)
    case failure(Error)
}

class NetworkRouter<EndPoint: EndPointType>: NetworkRouterType {
    
    private var task: URLSessionTask?
    private var route: EndPoint
    public typealias Void = ()
    
    init(route: EndPoint) {
        self.route = route
    }
    
    func request(completion: ((Result<EndPoint.ResponseModel, Error>) -> Void)?) {
        
        let session = URLSession.shared
        do {
            let request = try buildRequest()
            task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
                if let completion = completion {
                    self?.handleNetworkResponse(data: data, response: response, error: error, completion: completion)
                }
            })
        } catch {
            completion?(.failure(error))
        }
        self.task?.resume()
    }
    
    // MARK: - handle network response
    private func handleNetworkResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<EndPoint.ResponseModel, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200...299:
                guard let data = data
                    else {
                    completion(.failure(GetFailureReason.notFound))
                        return
                }
                do {
                    let model = try JSONDecoder().decode(EndPoint.ResponseModel.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            default:
                completion(.failure(GetFailureReason.notFound))
            }
        }
    }
    
    func buildRequest() throws -> URLRequest {
        let baseURL = ConfigurationManager.BaseURL
        let url = "\(baseURL)\(route.path.absolutePath)"
        let safeUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var urlRequest = URLRequest(url: URL(string: safeUrl!)!)
        urlRequest.allHTTPHeaderFields = route.headers
        urlRequest.httpMethod = route.httpMethod?.rawValue
        
        if route.httpMethod?.rawValue != "GET"{
            if let param = route.bodyParams {
                do {
                     urlRequest.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
                }catch {
                    print("failed To create request!")
                }
            }
        }
        
        return urlRequest
        
    }
    
}
