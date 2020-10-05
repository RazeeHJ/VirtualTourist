//
//  Sortable.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/27/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation

public protocol Sortable {
    var sortKey: Int { get }
    var hashKey: String { get }
}
