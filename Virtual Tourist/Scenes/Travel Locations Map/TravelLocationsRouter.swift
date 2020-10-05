//
//  TravelLocationsRouter.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/31/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import UIKit

@objc protocol TravelRoutingLogic {
    func routeToPhotoAlbum(segue: UIStoryboardSegue?, pin: Pin)
}

protocol TravelDataPassing
{
    var dataStore: TravelLocationDataStore? { get }
}

class TravelRouter: NSObject, TravelRoutingLogic, TravelDataPassing {
    weak var viewController: TravelLocationsViewController?
    var dataStore: TravelLocationDataStore?
    
    func routeToPhotoAlbum(segue: UIStoryboardSegue?, pin: Pin) {
        let latitude = pin.latitude
        let longitude = pin.longitude
 
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: PhotoAlbumViewController.Identifier) as! PhotoAlbumViewController
        
        dataStore?.latitude = latitude
        dataStore?.longitude =  longitude

        destinationVC.pinLatitude = latitude!
        destinationVC.pinLongitude = longitude!
        var destinationDS = destinationVC.router!.dataStore!
        passDataToPhotoAlbum(source: dataStore!, destination: &destinationDS)
        navigateToShowOrder(source: viewController!, destination: destinationVC)
    }
    
    func passDataToPhotoAlbum(source: TravelLocationDataStore, destination: inout PhotoAlbumDataStore) {
        destination.pinLatitude = source.latitude
        destination.pinLongitude = source.longitude
    }
    
    func navigateToShowOrder(source: TravelLocationsViewController, destination: PhotoAlbumViewController)
    {
        source.show(destination, sender: nil)
    }
}
