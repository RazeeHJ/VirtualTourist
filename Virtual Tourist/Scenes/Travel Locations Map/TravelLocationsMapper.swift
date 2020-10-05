//
//  TravelLocationsMapper.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/27/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import CoreLocation

protocol TravelMapperDisplayLogic {
    func mapToDisplayedPin(with pins: Pin) -> ShowPin.DisplayedPin
}

class TravelLocationsMapper: TravelMapperDisplayLogic {
    func mapToDisplayedPin(with pin: Pin) -> ShowPin.DisplayedPin {
        var displayed = ShowPin.DisplayedPin()
        displayed.latitude = pin.latitude ?? ""
        displayed.longitude = pin.longitude ?? ""
        
        return displayed
    }
}
