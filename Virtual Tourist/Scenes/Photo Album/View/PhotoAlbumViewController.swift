//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/29/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import UIKit
import MapKit
import CoreData

protocol PhotoDisplayLogic: class {
    func display(viewModel: ShowImage.Get.ViewModel)
}

class PhotoAlbumViewController: UIViewController, PhotoAlbumDataStore {
    static let Identifier = "PhotoAlbumViewController"
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var interactor: PhotoBusinessLogic?
    var presenter: PhotoPresentationLogic?
    var router: (NSObjectProtocol & PhotoAlbumRoutingLogic & PhotoAlbumDataPassing)?

    var displayedImages: [ShowImage.DisplayedImage] = []

    var pinLatitude: String?
    var pinLongitude: String?
    
    var page: Int = 1
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
      super.init(coder: aDecoder)
      setup()
    }
    
    // MARK: Setup

    func setup() {
        let viewController = self
        let interactor = PhotoAlbumInteractor()
        let presenter = PhotoAlbumPresenter()
        let router = PhotoAlbumRouter()
        
        viewController.interactor = interactor
        viewController.presenter = presenter
        viewController.router = router
        
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showPhotoAlbum()
        reloadCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionCell()
        configureCollectionView()
        setMap()
    }
    
    @IBAction func loadNewCollection(_ sender: Any) {
        self.page = self.page + 1
        let request = ShowImage.Get.Request(page: self.page)
        interactor?.search(with: request)
    }
}

extension PhotoAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedImages.count == 0 ? 20 : displayedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoAlbumCell.Identifier, for: indexPath) as! PhotoAlbumCell
        
        guard displayedImages.count > 0 else {
            cell.configure(with: nil)
            return cell
        }

        let displayModel = displayedImages[indexPath.row]
        let model = ImageCellModel(displayedImage: displayModel)
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = displayedImages[indexPath.row]
        interactor?.deletePhoto(with: ShowImage.Delete.Request(selectedPhoto))
        
        // Update UI
        displayedImages.remove(at: indexPath.row)
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
}

extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-20)/3

        return CGSize(width: width, height: width)
    }
}

extension PhotoAlbumViewController {
    func registerCollectionCell() {
        let collectionNib = UINib(nibName: PhotoAlbumCell.Identifier, bundle: nil)
        collectionView.register(collectionNib, forCellWithReuseIdentifier: PhotoAlbumCell.Identifier)
    }
    
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showPhotoAlbum() {
        let request = ShowImage.Get.Request(page: page)
        interactor?.loadPhotos(with: request)
    }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    func setMapRegion(coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func setMap() {
        let coordinate = CLLocationCoordinate2D(latitude: Double(pinLatitude!)!, longitude: Double(pinLongitude!)!)
        addAnnotation(coordinate: coordinate)
        setMapRegion(coordinate: coordinate)
    }
}

extension PhotoAlbumViewController: PhotoDisplayLogic {
    func display(viewModel: ShowImage.Get.ViewModel) {
        self.displayedImages = viewModel.display!
        reloadCollectionView()
    }
}
