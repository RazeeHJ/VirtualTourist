//
//  PhotoAlbumInteractor.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/28/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation
import MapKit

protocol PhotoBusinessLogic {
    func loadPhotos(with request: ShowImage.Get.Request)
    func search(with request: ShowImage.Get.Request)
    func deletePhoto(with request: ShowImage.Delete.Request)
}

protocol PhotoAlbumDataStore {
    var pinLatitude: String? {get set}
    var pinLongitude: String? {get set}
}

class PhotoAlbumInteractor: PhotoBusinessLogic, PhotoAlbumDataStore {
    var worker: PhotoWorkerProtocol?
    var presenter: PhotoPresentationLogic?
    var mapper: PhotoMapperDisplayLogic?
        
    var pinLatitude: String? 
    var pinLongitude: String?
    
    private var photoImages: [PhotoImage] = [] {
        didSet {
            photoImages.forEach { (photoImages) in
                self.worker?.downloadPhoto(farmId: photoImages.farm, serverId: photoImages.server, id: photoImages.id, secret: photoImages.secret, completion: { (result, imageUrl)  in
                    switch result {
                    case .success(let image):
                        var photo = ShowImage.DisplayedImage()
                        photo.image = image
                        photo.imageUrl = imageUrl
                        photo.title = photoImages.title

                        self.createPhoto(with: ShowImage.Create.Request(photo)) { (photo) in
                            print("createPhoto")
                        }
                        
                        self.photos.append(photo)
                    case .failure(_):
                        return
                    }
                })
            }
        }
    }
    
    private var photos: [ShowImage.DisplayedImage] = [] {
        didSet {
            var response = ShowImage.Get.Response()
            response.photos = photos
            self.presenter?.present(response: response)
        }
    }
    
    init(worker: PhotoWorkerProtocol, presenter: PhotoPresentationLogic, mapper: PhotoMapperDisplayLogic) {
        self.worker = worker
        self.presenter = presenter
        self.mapper = mapper
    }
    
    convenience init(dataController: DataController) {
        self.init(worker: PhotoAlbumWorker(client: VirtualClient(network: NetworkRequest())), presenter: PhotoAlbumPresenter(), mapper: PhotoAlbumMapper())
    }
    
    convenience init() {
        self.init(worker: PhotoAlbumWorker(client: VirtualClient(network: NetworkRequest())), presenter: PhotoAlbumPresenter(), mapper: PhotoAlbumMapper())
    }
    
    func loadPhotos(with request: ShowImage.Get.Request) {
        var fetchedPhotos: [Photo]?
        
        fetchPin() { (pin) in
            guard let pin = pin else {return}
            
            // Check photos in Core
            self.fetchPhotos(with: pin) { (photos) in
                fetchedPhotos = photos
                fetchedPhotos?.forEach({ (photo) in
                    let mapper = self.mapper?.mapToDisplayedImage(with: photo)
                    self.photos.append(mapper!)
                })
            }
            
            guard fetchedPhotos?.count == 0 else {return}
            
            // Search new photos
            self.search(with: request)
        }
    }
    
    func deletePhoto(with request: ShowImage.Delete.Request) {
        self.worker?.deletePhoto(photoToDelete: request, completion: { (photo, error) in
            print("deletePhoto")
        })
    }
}

extension PhotoAlbumInteractor {
    // MARK: - Flickr
    func search(with request: ShowImage.Get.Request) {
        self.worker?.search(by: request, latitude: pinLatitude!, longitude: pinLongitude!, completion: { (result) in
            switch result {
            case .success(let album):
                guard let photos = album.data.photos else {return}
                self.photoImages = photos.photo
                self.photos = []
            case .error(let error):
                let response = ShowImage.Get.Response(error: .CannotFetch(error.data.message))
                self.presenter?.present(response: response)
            }
        })
    }
}

extension PhotoAlbumInteractor {
    // MARK: - Core Data Photo
    
    func fetchPhotos(with pin: Pin, completion: @escaping ([Photo]?) -> Void) {
        self.worker?.fetchPhotos(pin: pin, completion: { (photos, error) in
            completion(photos)
        })
    }
    
    func createPhoto(with request: ShowImage.Create.Request, completion: @escaping (Photo?) -> Void) {
        self.worker?.createPhoto(photoToCreate: request, latitude: self.pinLatitude!, longitude: self.pinLongitude!, completion: { (photo, error) in
            completion(photo)
        })
    }
}

extension PhotoAlbumInteractor {
    // MARK: - Core Data Pin
    
    func fetchPin(completion: @escaping (Pin?) -> Void) {
        self.worker?.fetchPin(latitude: self.pinLatitude!, longitude: self.pinLongitude!, completion: { (pin, error) in
            completion(pin)
        })
    }
}
