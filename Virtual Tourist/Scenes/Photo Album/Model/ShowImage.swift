//
//  ShowAlbum.swift
//  Virtual Tourist
//
//  Created by Razee Hussein-Jamal on 6/1/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation

enum ShowImage {
    enum DisplayModelType: Sortable {
        case success(DisplayedImage), error(DisplayedImage)
        var sortKey: Int { get { return self.value?.id ?? 0 } }
        var hashKey: String { get { return self.value?.objectKey ?? "" } }
    }
    
    struct DisplayedImage {
        var id: Int?
        var image: Data?
        var imageUrl: String?
        var title: String?        
        var objectKey: String {
            return String(describing: id) + String(describing: image)
        }
        
        init() {
            self.id = 0
            self.image = nil
            self.imageUrl = ""
            self.title = ""
        }
    }
    
    enum Get {
        struct Request {
            var latitude: String?
            var longitude: String?
            var page: Int = 0
            
            init(page: Int) {
                self.page = page
            }
        }
        
        struct Response {
            var photos: [DisplayedImage]?
            var error: CoreDataStoreError?
            
            init(_ photos: [DisplayedImage]) {
                self.photos = photos
            }
            
            init(error: CoreDataStoreError? = nil) {
                self.error = error
            }
        }
        
        struct ViewModel {
            var display: [DisplayedImage]?
        }
    }
    
    enum Create {
        struct Request {
            var data: DisplayedImage?
            
            init(_ data: DisplayedImage) {
                self.data = data
            }
        }
    }
    
    enum Delete {
        struct Request {
            var data: DisplayedImage?
            
            init(_ data: DisplayedImage) {
                self.data = data
            }
        }
    }
}

extension ShowImage.DisplayModelType: Equatable {
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
    
    var isError: Bool {
        switch self {
        case .error:
            return true
        default:
            return false
        }
    }
    
    var value: ShowImage.DisplayedImage? {
        switch self {
            case .success(let model):
                return model
            case .error(let model):
                return model
        }
    }
    
    static func == (lhs: ShowImage.DisplayModelType, rhs: ShowImage.DisplayModelType) -> Bool {
        let lhsValue = lhs.value
        let rhsValue = rhs.value
        return lhsValue?.id == rhsValue?.id
    }
}
