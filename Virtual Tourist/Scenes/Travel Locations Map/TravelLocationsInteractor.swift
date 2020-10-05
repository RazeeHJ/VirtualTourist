//
//  TravelLocationsInteractor.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/27/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation
import MapKit

let MAPKEY = "MAP_KEY"

protocol TravelBusinessLogic {
    func fetchPins(with request: ShowPin.Get.Request)
    func fetchPin(with request: ShowPin.Get.Request)
    func createPin(with pin: ShowPin.Create.Request)
    
    func fetchMapState() -> MapUserDefaults?
    func createMapState(with state: MapUserDefaults)
}

protocol TravelLocationDataStore {
    var latitude: String? {get set}
    var longitude: String? {get set}
}

class TravelLocationsInteractor: TravelLocationDataStore {
    var worker: TravelWorkerProtocol?
    var userDefaultsWorker: UserDefaultsWorker

    var mapper: TravelMapperDisplayLogic?
    var presenter: TravelPresentationLogic?

    // Data Store
    var latitude: String?
    var longitude: String?
    
    var response: [ShowPin.DisplayedPin] = []
    var mapState: MapUserDefaults?
    
    // MARK: Initialize
    
    init(worker: TravelWorkerProtocol, userDefaultsWorker: UserDefaultsWorker,mapper: TravelLocationsMapper, presenter: TravelLocationsPresenter) {
        self.worker = worker
        self.userDefaultsWorker = userDefaultsWorker
        self.mapper = mapper
        self.presenter = presenter
    }
    
    convenience init() {
        self.init(worker: TravelLocationsWorker(), userDefaultsWorker: UserDefaultsWorker(), mapper: TravelLocationsMapper(), presenter: TravelLocationsPresenter())
    }
}

extension TravelLocationsInteractor: TravelBusinessLogic {
    func fetchPins(with request: ShowPin.Get.Request) {
        self.worker?.fetchPins(completion: { pins, error in
            guard let pins = pins else {
                return
            }
            
            pins.forEach { pin in
                let mapper = self.mapper?.mapToDisplayedPin(with: pin)
                self.response.append(mapper!)
            }
            self.presenter?.present(response: self.response)
        })
    }
    
    func fetchPin(with request: ShowPin.Get.Request) {
        self.worker?.fetchPin(latitude: request.latitude ?? "", longitude: request.longitude ?? "", completion: { (pin, error) in
            
            guard let pin = pin else {
                return
            }
            self.presenter?.present(response: pin)
        })
    }
    
    func createPin(with request: ShowPin.Create.Request) {
        self.worker?.createPin(with: request, completion: { (pin, error) in})
    }
}

extension TravelLocationsInteractor {
    func fetchMapState() -> MapUserDefaults? {
        self.userDefaultsWorker.fetchUserDefaults(by: MAPKEY) { (state) in
            self.mapState = state.first
        }
        return mapState
    }
    
    func createMapState(with state: MapUserDefaults) {
        self.userDefaultsWorker.insertUserDefaults(by: MAPKEY, with: state)
    }
}
