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
    var photos: [Photo] { get }
    func loadPhoto()
    func addRandomPhoto()
    func delete(photo: Photo)
    func swap(sourceIndex: Int, destinationIndex: Int)
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
        
    }
    
    func delete(photo: Photo) {
        
    }
    
    func swap(sourceIndex: Int, destinationIndex: Int) {
        
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
}

private extension Array where Element: Photo {
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
