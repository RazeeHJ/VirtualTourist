//
//  PhotoAlbumRouter.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/31/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation

@objc protocol PhotoAlbumRoutingLogic {

}

protocol PhotoAlbumDataPassing
{
  var dataStore: PhotoAlbumDataStore? { get }
}

class PhotoAlbumRouter: NSObject, PhotoAlbumRoutingLogic, PhotoAlbumDataPassing {
    weak var viewController: PhotoAlbumViewController?
    var dataStore: PhotoAlbumDataStore?
    
}
