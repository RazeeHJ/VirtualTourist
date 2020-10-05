//
//  VirtualClient.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/27/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation

protocol VirtualProtocol {
    func fetchPhotos<T: Decodable>(with request: URLRequest, method: HTTPMethod, using session: URLSession, completion: @escaping(VirtualResult<T>) -> Void)
    func downloadPhoto(with request: URLRequest, method: HTTPMethod, using session: URLSession, completion: @escaping(Result<Data,Error>, String) -> Void)
}

class VirtualClient: VirtualProtocol {
    let network: NetworkRequest
    
    init(network: NetworkRequest) {
        self.network = network
    }
    
    func fetchPhotos<T>(with request: URLRequest, method: HTTPMethod, using session: URLSession, completion: @escaping (VirtualResult<T>) -> Void) {
        self.network.makeRequest(with: request, method: method, completion: completion)
    }
    
    func downloadPhoto(with request: URLRequest, method: HTTPMethod, using session: URLSession, completion: @escaping(Result<Data,Error>, String) -> Void) {
        
        let task = session.dataTask(with: request, method: method) { (result) in
            switch result {
            case .success(let image):
                print(image)
                completion(Result.success(image), request.url!.absoluteString)
                break
            case .failure(let error):
                print(error)
                completion(Result.failure(error), request.url!.absoluteString)
                break
            }
        }
        task.resume()
    }
}
