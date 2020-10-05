//
//  MapState.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 6/6/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation

struct MapUserDefaults: Codable {
    var spanLatitude: Double
    var spanLongitude: Double
    var centerLatitude: Double
    var centerLongitude: Double
    
    var objectId: String {
        return "\(spanLatitude):\(spanLongitude)"
    }
    
    init() {
        self.spanLatitude = 0.0
        self.spanLongitude = 0.0
        self.centerLatitude = 0.0
        self.centerLongitude = 0.0
    }
}
