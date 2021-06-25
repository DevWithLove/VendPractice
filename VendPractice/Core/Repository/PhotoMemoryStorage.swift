//
//  PhotoMemoryStorage.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

import Foundation

class PhotoMemoryStorage: PhotoRepositoryProtocol {
    private var photos: [Photo] = []
    
    func get() throws -> [Photo] {
        return photos
    }
    
    func save(_ photo: Photo) throws {
        
        // Update the photo, if the photo existing
        if let index = photos.firstIndex(of: photo) {
            photos[index] = photo
            return
        }
        // Insert as new photo
        photos.append(photo)
    }
    
    func delete(_ photo: Photo) throws {
        photos.removeAll(where: { $0 == photo })
    }
}
