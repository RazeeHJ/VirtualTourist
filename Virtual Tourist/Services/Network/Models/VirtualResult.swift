//
//  Wrapper.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/26/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation

enum VirtualResult<T: Decodable> {
    case success(VirtualResponse<T>)
    case error(VirtualResponse<MyError>)
}

struct VirtualResponse<T: Decodable> {
    let data: T
}

enum MyError: Error, Decodable {
    init(from decoder: Decoder) throws {
        self = .runtimeError()
    }
    
    case networkError(String = "Failed to perfom request")
    case runtimeError(String = "Oops, Something went wrong")
    
    var message: String {
        switch self {
        case .networkError(let message),
             .runtimeError(let message):
            return message
        }
    }
}
