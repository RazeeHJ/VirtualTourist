//
//  PhotoAlbumWorker.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/28/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation
import CoreData

protocol PhotoWorkerProtocol {
    func search(by request: ShowImage.Get.Request, latitude: String, longitude: String, completion: @escaping (VirtualResult<PhotoAlbum>) -> Void)
    func downloadPhoto(farmId: Int, serverId: String, id: String, secret: String, completion:  @escaping (Result<Data,Error>,String) -> Void)
    
    func fetchPhotos(pin: Pin, completion: @escaping ([Photo]?, CoreDataStoreError?) -> Void)
    func createPhoto(photoToCreate: ShowImage.Create.Request, latitude: String, longitude: String, completion: @escaping (Photo?, CoreDataStoreError?) -> Void)
    func deletePhoto(photoToDelete: ShowImage.Delete.Request, completion: @escaping (Photo?, CoreDataStoreError?) -> Void)
    
    func fetchPin(latitude: String, longitude: String, completion: @escaping (Pin?, CoreDataStoreError?) -> Void)
}

class PhotoAlbumWorker: DataController, PhotoWorkerProtocol {
    var client: VirtualClient?
    
    init(client: VirtualClient) {
        self.client = client
    }
    
    func search(by request: ShowImage.Get.Request, latitude: String, longitude: String, completion: @escaping (VirtualResult<PhotoAlbum>) -> Void) {
        self.client?.fetchPhotos(with: Endpoint.flickrSearch(by: latitude, longitude: longitude, page: String(describing: request.page)).request, method: .get, using: .shared, completion: completion)
    }
    
    func downloadPhoto(farmId: Int, serverId: String, id: String, secret: String, completion:  @escaping (Result<Data,Error>,String) -> Void) {
        self.client?.downloadPhoto(with: Endpoint.flickrPhoto(farmId: farmId, serverId: serverId, id: id, secret: secret).request, method: .get, using: .shared, completion: (completion))
    }
}

extension PhotoAlbumWorker {
    func fetchPhotos(pin: Pin, completion: @escaping ([Photo]?, CoreDataStoreError?) -> Void) {
        do {
            let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
            let photos = try DataController.mainManagedObjectContext.fetch(fetchRequest)
            
            completion(photos, nil)
        } catch {
            DispatchQueue.main.async {
                completion(nil, CoreDataStoreError.CannotFetch("Can not fetch photo"))
            }
        }
    }
    
    func createPhoto(photoToCreate: ShowImage.Create.Request, latitude: String, longitude: String, completion: @escaping (Photo?, CoreDataStoreError?) -> Void) {
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
            fetchRequest.predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", latitude, longitude)
            
            let pins = try DataController.mainManagedObjectContext.fetch(fetchRequest) as! [Pin]
            if let pin = pins.first {
                let photo = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: DataController.mainManagedObjectContext) as! Photo
                photo.image = photoToCreate.data?.image
                photo.imageUrl = photoToCreate.data?.imageUrl
                photo.title = photoToCreate.data?.title
                photo.pin = pin
                do {
                    try DataController.mainManagedObjectContext.save()
                    DispatchQueue.main.async {
                        completion(photo, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, CoreDataStoreError.CannotFetch("Can not fetch photo"))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, CoreDataStoreError.CannotFetch("Can not fetch photo"))
                }
            }
        } catch {
            DispatchQueue.main.async {
                completion(nil, CoreDataStoreError.CannotFetch("Can not fetch photo"))
            }
        }
    }
    
    func deletePhoto(photoToDelete: ShowImage.Delete.Request, completion: @escaping (Photo?, CoreDataStoreError?) -> Void) {
        let url = (photoToDelete.data?.imageUrl)! as String
        
        do {
            let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "imageUrl == %@", url)
            let photos = try DataController.mainManagedObjectContext.fetch(fetchRequest)
            
            if let photo = photos.first {
                DataController.mainManagedObjectContext.delete(photo)
                try DataController.mainManagedObjectContext.save()
                
                DispatchQueue.main.async {
                    completion(photo, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, CoreDataStoreError.CannotFetch("Can not fetch photo"))
                }
            }
            
        } catch {
            DispatchQueue.main.async {
                completion(nil, CoreDataStoreError.CannotFetch("Can not fetch photo"))
            }
        }
    }
}

extension PhotoAlbumWorker {
    func fetchPin(latitude: String, longitude: String, completion: @escaping (Pin?, CoreDataStoreError?) -> Void) {
        do {
            let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", latitude, longitude)
            
            let pins = try DataController.mainManagedObjectContext.fetch(fetchRequest)
            
            if let pin = pins.first {
                DispatchQueue.main.async {
                    completion(pin,nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, CoreDataStoreError.CannotFetch("Can not fetch pin"))}
            }
        } catch {
            DispatchQueue.main.async {
                completion(nil, CoreDataStoreError.CannotFetch("Can not fetch pin"))
            }
        }
    }
}

