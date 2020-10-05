//
//  TravelLocationsPresenter.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/27/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation

protocol TravelPresentationLogic {
    func present(response: [ShowPin.DisplayedPin])
    func present(response: Pin)
}

class TravelLocationsPresenter: TravelPresentationLogic {
    weak var viewController: TravelDisplayLogic?
    
    func present(response: [ShowPin.DisplayedPin]) {
        viewController?.display(with: response)
    }
    
    func present(response: Pin) {
        viewController?.display(with: response)
    }
}
