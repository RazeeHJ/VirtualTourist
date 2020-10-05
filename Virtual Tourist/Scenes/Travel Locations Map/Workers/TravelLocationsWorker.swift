//
//  TravelLocationsWorker.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/27/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation
import CoreData

protocol TravelWorkerProtocol {
    func fetchPins(completion: @escaping (_ pins: [Pin]?, _ error: CoreDataStoreError?) -> Void)
    func fetchPin(latitude: String, longitude: String, completion: @escaping (Pin?, CoreDataStoreError?) -> Void)
    func createPin(with pins: ShowPin.Create.Request, completion: @escaping (Pin?, CoreDataStoreError?) -> Void)
    
}

class TravelLocationsWorker: DataController, TravelWorkerProtocol {
    func fetchPins(completion: @escaping (_ pins: [Pin]?, _ error: CoreDataStoreError?)  -> Void) {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
            let pins = try DataController.mainManagedObjectContext.fetch(fetchRequest) as! [Pin]
            
            DispatchQueue.main.async {
                completion(pins, nil)
            }
        } catch {
            DispatchQueue.main.async {
                completion(nil, CoreDataStoreError.CannotFetch("Can not fetch pin"))
            }
        }
    }
    
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
    
    func createPin(with data: ShowPin.Create.Request, completion: @escaping (Pin?, CoreDataStoreError?) -> Void) {
        let pin = NSEntityDescription.insertNewObject(forEntityName: "Pin", into: DataController.mainManagedObjectContext) as! Pin
        
        pin.latitude = "\(data.latitude)"
        pin.longitude = "\(data.longitude)"
        
        try? DataController.mainManagedObjectContext.save()
    }
}
