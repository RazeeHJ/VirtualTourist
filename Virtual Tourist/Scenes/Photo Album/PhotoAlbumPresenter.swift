//
//  PhotoAlbumPresenter.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/28/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation

protocol PhotoPresentationLogic {
    func present(response: ShowImage.Get.Response)
}

class PhotoAlbumPresenter: PhotoPresentationLogic {
    weak var viewController: PhotoDisplayLogic?

    func present(response: ShowImage.Get.Response) {
        var displayedImages: [ShowImage.DisplayedImage] = []

        for image in response.photos! {
            var displayedImage = ShowImage.DisplayedImage()
            displayedImage.image = image.image
            displayedImage.imageUrl = image.imageUrl
            displayedImage.title = image.title
            displayedImages.append(displayedImage)
        }
        let viewModel = ShowImage.Get.ViewModel(display: displayedImages)
        viewController?.display(viewModel: viewModel)
    }
}
