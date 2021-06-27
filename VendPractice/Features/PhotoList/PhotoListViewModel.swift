//
//  PhotoListViewModel.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

import Foundation

protocol PhotoViewModelDelegate: AnyObject {
    func displayError(_ error: PhotoListError)
    func didLoadData()
}

protocol PhotoListViewModelProtocol {
    var delegate: PhotoViewModelDelegate? { get set }
    /// List of photos from the local repository
    var photos: [Photo] { get }
    /// Number of photos is in the pool
    var numberOfPhotosLeft: Int { get }
    /// Load photos from the local repository and web service
    func loadPhoto()
    /// Get a random photo from the pool and add it to the local repository
    func addRandomPhoto()
    /// Delete the selected photo from the local repository and put it back to the pool
    func delete(photo: Photo)
    /// Re-order the photos
    func reorder(sourceIndex: Int, destinationIndex: Int)
}

class PhotoListViewModel {

    private let photoWebService: PhotoWebServiceProtocol
    private let photoRepository: PhotoRepositoryProtocol
    private var photoPool: [Photo] = []
    
    var photos: [Photo] = []
    weak var delegate: PhotoViewModelDelegate?

    // MARK: - Init
    
    init(photoWebService: PhotoWebServiceProtocol, photoRepository: PhotoRepositoryProtocol) {
        self.photoWebService = photoWebService
        self.photoRepository = photoRepository
    }
}

extension PhotoListViewModel: PhotoListViewModelProtocol {
 
    var numberOfPhotosLeft: Int {
        return photoPool.count
    }
    
    func loadPhoto() {
        photoWebService.getPhotos { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photoDtos):
                self.setPhoto(photoDtos: photoDtos)
            case .failure:
                self.delegate?.displayError(.loadRemotePhotoFailed)
            }
        }
    }
    
    func addRandomPhoto() {
        // Get a random photo from the pool.
        // Display a client error to the user if the pool is empty
        guard let index = photoPool.indices.randomElement() else {
            delegate?.displayError(.noPhotoAvailable)
            return
        }
        
        do {
            // Get the photo from the pool and set the displayOrder
            let photo = photoPool[index]
            photo.displayOrder = photos.endIndex
            // Save the photo to repository and remove it from the pool
            try photoRepository.save(photo)
            photos.append(photoPool.remove(at: index))
        } catch {
            delegate?.displayError(.unableToSavePhoto)
        }
    }
    
    func delete(photo: Photo) {
        do {
            // Delete the photo from repository and photo list
            try photoRepository.delete(photo)
            photos.removeAll(where: {$0 == photo})
            // Add the photo back to the pool, so it will be available for next pick up
            photoPool.append(photo)
            // Tell the view to refresh the list
            delegate?.didLoadData()
        } catch {
            delegate?.displayError(.unableToDeletePhoto(photo))
        }
    }
    
    func reorder(sourceIndex: Int, destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        let photo = photos.remove(at: sourceIndex)
        photos.insert(photo, at: destinationIndex)
        updateDisplayOrders()
    }
    
    // MARK: - Helpers
    
    private func setPhoto(photoDtos: [PhotoDto]?) {
        do {
            // Get photos from local storage and sorted by display order
            photos = try photoRepository.get().sortedByDisplayOrder()
            
            // Remove the duplicated photos from the remotePhotos if the photos have been added,
            // So no duplicated photos will be picked again
            if let remotePhotos = photoDtos?.compactMap({$0.toPhoto()}) {
                photoPool = Array(Set(remotePhotos).subtracting(self.photos))
            }
            
            // Tell the view, the data has been loaded
            delegate?.didLoadData()
        } catch {
            delegate?.displayError(.unableToGetPhotosFromLocalRepository)
        }
    }
    
    private func updateDisplayOrders() {
        for (index, photo) in photos.enumerated() {
            photo.displayOrder = index
            try? photoRepository.save(photo)
        }
    }
}



private extension Array where Element == Photo {
    
    func sortedByDisplayOrder()-> [Photo] {
        let photos = filter({$0.displayOrder != nil})
        return photos.sorted(by: {$0.displayOrder! < $1.displayOrder!})
    }
    
}

private extension PhotoDto {
    func toPhoto() -> Photo? {
        guard let id = id,
              let author = author,
              let downloadUrl = downloadUrl else { return nil }
        return Photo(id: id, author: author, downloadUrl: downloadUrl, displayOrder: nil)
    }
}

enum ArrayError: Error {
    case cannotFindTheItem
}
