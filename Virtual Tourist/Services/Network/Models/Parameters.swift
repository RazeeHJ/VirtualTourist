//
//  Parameters.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/29/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation

struct ParameterKeys {
    static let METHOD = "method"
    static let APIKEY = "api_key"
    static let LATITUDE = "lat"
    static let LONGITUDE = "lon"
    static let PERPAGE = "per_page"
    static let PAGE = "page"
    static let FORMAT = "format"
    static let JSONCALLBACK = "nojsoncallback"
}

struct ParameterValues {
    static let METHOD = "flickr.photos.search"
    static let APIKEY = "224a35d9dc473bc5b1fd11443c8448d1"
    static let LATITUDE = ""
    static let LONGITUDE = ""
    static let PERPAGE = "10"
    static let PAGE = ""
    static let FORMAT = "json"
    static let JSONCALLBACK = "1"
}
