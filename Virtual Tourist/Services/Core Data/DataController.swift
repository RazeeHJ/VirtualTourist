//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 5/27/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import CoreData

let VirtualTouristIdentifier = "VirtualTourist"

class DataController {
     // MARK: - Managed object contexts
     
     static private var _mainManagedObjectContext: NSManagedObjectContext?
     static var mainManagedObjectContext: NSManagedObjectContext
     {
       get
       {
         if _mainManagedObjectContext == nil {
           _mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
         }
         return _mainManagedObjectContext!
       }
       set
       {
         _mainManagedObjectContext = newValue
       }
     }
     
     // MARK: - Object lifecycle
     
     init()
     {
       // This resource is the same name as your xcdatamodeld contained in your project.
       guard let modelURL = Bundle.main.url(forResource: VirtualTouristIdentifier, withExtension: "momd") else {
         fatalError("Error loading model from bundle")
       }
       
       // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
       guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
         fatalError("Error initializing mom from: \(modelURL)")
       }
       
       let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
       DataController.mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
       DataController.mainManagedObjectContext.persistentStoreCoordinator = psc
       
       let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       let docURL = urls[urls.endIndex-1]
       /* The directory the application uses to store the Core Data store file.
        This code uses a file named "DataModel.sqlite" in the application's documents directory.
        */
       let storeURL = docURL.appendingPathComponent("VirtualTouristIdentifier.sqlite")
       do {
         try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
       } catch {
         fatalError("Error migrating store: \(error)")
       }
     }
     
     deinit
     {
       do {
         try DataController.mainManagedObjectContext.save()
       } catch {
         fatalError("Error deinitializing main managed object context")
       }
     }
}
