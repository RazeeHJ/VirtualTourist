//
//  TravelLocationsViewController.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/27/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import UIKit
import MapKit

protocol TravelDisplayLogic: class {
    func display(with pins: [ShowPin.DisplayedPin])
    func display(with pin: Pin)
}

class TravelLocationsViewController: UIViewController {
    static let Identifier = "TravelLocationsViewController"
    
    @IBOutlet weak var mapView: MKMapView!
    var gesture: UILongPressGestureRecognizer?
    
    var interactor: TravelBusinessLogic?
    var presenter: TravelPresentationLogic?
    var router: (NSObjectProtocol & TravelRoutingLogic & TravelDataPassing)?
    
    var coordinateSpan: MKCoordinateSpan?
    var coordinateCenter: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadPins()
        setupMapView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        createMapState()
    }
    
    @objc func handleGesture(_ sender: UILongPressGestureRecognizer) {
        var coordinate: CLLocationCoordinate2D?
        if sender.state == .began {
            let location = sender.location(in: self.mapView)
            coordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
            
            // Add to Map View
            addAnnotation(location: coordinate!)
            
            // Create Pin to Core Data
            interactor?.createPin(with: handleAddRequest(coordinate: coordinate!))
            
            // Fetch Pin
            loadPin(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
        }
    }
}

extension TravelLocationsViewController {
    // MARK: Setup
    
    func setup() {
        let viewController = self
        let interactor = TravelLocationsInteractor()
        let presenter = TravelLocationsPresenter()
        let router = TravelRouter()
        
        viewController.interactor = interactor
        viewController.presenter = presenter
        viewController.router = router
        
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func setupMapView() {
        self.mapView.delegate = self
        
        guard let state = loadMapState() else {return}
        let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(state.centerLatitude, state.centerLongitude), span: MKCoordinateSpan(latitudeDelta: state.spanLatitude, longitudeDelta: state.spanLongitude))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func setupGesture() {
        self.gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        self.view.addGestureRecognizer(self.gesture!)
    }
    
    func loadMapState() -> MapUserDefaults? {
        return interactor?.fetchMapState()
    }
    
    func createMapState() {
        var state = MapUserDefaults()
        state.centerLatitude = Double(coordinateCenter!.latitude)
        state.centerLongitude = Double(coordinateCenter!.longitude)
        state.spanLatitude = Double(coordinateSpan!.latitudeDelta)
        state.spanLongitude =  Double(coordinateSpan!.longitudeDelta)
        interactor?.createMapState(with: state)
    }
}

extension TravelLocationsViewController {
    func addAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
    
    func handleAddRequest(coordinate: CLLocationCoordinate2D) -> ShowPin.Create.Request {
        return ShowPin.Create.Request(latitude: "\(coordinate.latitude)", longitude: "\(coordinate.longitude)")
    }
    
    func loadPins() {
        let request = ShowPin.Get.Request()
        interactor?.fetchPins(with: request)
    }
    
    func loadPin(latitude: Double, longitude: Double) {
        let latitude = String(describing: latitude)
        let longitude = String(describing: longitude)
        
        let request = ShowPin.Get.Request(latitude: latitude, longitude: longitude)
        interactor?.fetchPin(with: request)
    }
}

extension TravelLocationsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view.annotation != nil else { return }
        
        loadPin(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        coordinateSpan = mapView.region.span
        coordinateCenter = mapView.region.center
    }
}

extension TravelLocationsViewController: TravelDisplayLogic {
    // MARK: Display
    
    func display(with pins: [ShowPin.DisplayedPin]) {
        for pin in pins {
            let latitude = Double(pin.latitude)! as Double
            let longitude = Double(pin.longitude)! as Double
            
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            addAnnotation(location: location)
        }
    }
    
    func display(with pin: Pin) {
        self.router?.routeToPhotoAlbum(segue: nil, pin: pin)
    }
}
