//
//  VirtualClient.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/26/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation

extension URLSession {
    func dataTask(with url: URLRequest, method: HttpMethod, completionHandler: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        dataTask(with: url) { data, _, error in
            if let error = error {
                completionHandler(.failure(error))
            } else {
                completionHandler(.success(data ?? Data()))
            }
        }
    }
}

protocol NetworkRequest {
    func request<T: Decodable>(with request: URLRequest, using session: URLSession, completion: @escaping(VirtualResult<T>) -> Void)
}

extension NetworkRequest {
    
    func request<T: Decodable>(with request: URLRequest , using session: URLSession = .shared, completion: @escaping (VirtualResult<T>) -> Void) {
        
        let task = session.dataTask(with: request, method: .get) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoded = try! JSONDecoder().decode(T.self, from: data)
                    let response = VirtualResponse(data: decoded)
                    completion(VirtualResult.success(response))
                }
            case .failure(let error):
                let response = VirtualResponse(data: MyError.networkError(error.localizedDescription))
                completion(VirtualResult.error(response))
            }
        }
        
        task.resume()
    }
}
 

