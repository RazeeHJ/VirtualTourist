//
//  PhotoAlbumMapper.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 6/5/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import CoreLocation

protocol PhotoMapperDisplayLogic {
    func mapToDisplayedImage(with photo: Photo) -> ShowImage.DisplayedImage
}

class PhotoAlbumMapper: PhotoMapperDisplayLogic {
    func mapToDisplayedImage(with photo: Photo) -> ShowImage.DisplayedImage {
        var displayed = ShowImage.DisplayedImage()
        displayed.image = photo.image
        return displayed
    }
}
