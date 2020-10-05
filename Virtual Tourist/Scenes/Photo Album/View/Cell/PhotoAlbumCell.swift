//
//  PhotoAlbumCell.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/31/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import UIKit

class PhotoAlbumCell: UICollectionViewCell {
    static let Identifier = "PhotoAlbumCell"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func configure(with model: ImageCellModel?) {
        if model == nil  {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            self.image.image = UIImage(data: (model?.displayedImage.image)!)
        }
    }
}

struct ImageCellModel {
    var displayedImage: ShowImage.DisplayedImage
}
