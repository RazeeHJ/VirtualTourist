//
//  ShowMapState.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/28/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation

enum ShowPin {
    enum DisplayModelType: Sortable {
        case success(DisplayedPin), error(DisplayedPin)
        var sortKey: Int { get { return self.value?.id ?? 0 } }
        var hashKey: String { get { return self.value?.objectKey ?? "" } }
    }
    
    struct DisplayedPin {
        var id: Int?
        var latitude: String
        var longitude: String
        var objectKey: String {
            return "\(String(describing: id)):\(latitude),\(longitude)"
        }
        
        init() {
            self.id = 0
            self.latitude = ""
            self.longitude = ""
        }
    }
    
    enum Get {
        struct Request {
            var latitude: String?
            var longitude: String?
        }
        
        struct Response {
            var pins: [DisplayedPin]?
            var error: CoreDataStoreError?
            
            init(pins: [DisplayedPin]) {
                self.pins = pins
            }
            
            init(error: CoreDataStoreError? = nil) {
                self.error = error
            }
        }
    }
    
    enum Create {
        struct Request {
            var latitude: String
            var longitude: String
            
            init(latitude: String, longitude: String) {
                self.latitude = latitude
                self.longitude = longitude
            }
        }
    }
}

extension ShowPin.DisplayModelType: Equatable {
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
    
    var isError: Bool {
        switch self {
        case .error:
            return true
        default:
            return false
        }
    }
    
    var value: ShowPin.DisplayedPin? {
        switch self {
        case .success(let model):
            return model
        case .error(let model):
            return model
        }
    }
    
    static func == (lhs: ShowPin.DisplayModelType, rhs: ShowPin.DisplayModelType) -> Bool {
        let lhsValue = lhs.value
        let rhsValue = rhs.value
        return lhsValue?.id == rhsValue?.id
    }
}

