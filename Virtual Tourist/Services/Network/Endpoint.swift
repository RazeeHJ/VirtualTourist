//
//  Endpoint.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/26/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation

struct Endpoint {
    var host: String?
    var path: String
    var method: HTTPMethod?
    var headers: HTTPHeaders?
    var queryItems: [URLQueryItem]?
    var pathExtension: String?
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
  
        print("URL", url)
        return url
    }
    
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method?.rawValue
        if let headers = headers {
            for(headerField, headerValue) in headers {
                request.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        return request
    }
}

extension Endpoint {
    static func flickrSearch(by latitude: String, longitude: String, page: String) -> Endpoint {
        return Endpoint(host: URLHost.flickr.rawValue, path: HTTPPath.search.rawValue, method: .get, queryItems:
            [
                URLQueryItem(name: ParameterKeys.METHOD, value:  ParameterValues.METHOD),
                URLQueryItem(name: ParameterKeys.APIKEY, value: ParameterValues.APIKEY),
                URLQueryItem(name: ParameterKeys.LATITUDE, value: latitude),
                URLQueryItem(name: ParameterKeys.LONGITUDE, value: latitude),
                URLQueryItem(name: ParameterKeys.PERPAGE, value: ParameterValues.PERPAGE),
                URLQueryItem(name: ParameterKeys.PAGE, value: page),
                URLQueryItem(name: ParameterKeys.FORMAT, value: ParameterValues.FORMAT),
                URLQueryItem(name: ParameterKeys.JSONCALLBACK, value: ParameterValues.JSONCALLBACK)
            ])
    }
    
    static func flickrPhoto(farmId: Int, serverId: String, id: String, secret: String) -> Endpoint {
        let path = "/\(serverId)/\(id)_\(secret).jpg"
        let host = "farm\(farmId).staticflickr.com"
        return Endpoint(host: host,
                        path: path, method: .get)
    }
}


