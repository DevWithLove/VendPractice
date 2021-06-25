//
//  PhotoListError.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

enum PhotoListError: Error {
    case loadRemotePhotoFailed
    case notPhotoAvailable
    case unableToDeletePhoto(Photo)
    case unableToSwapPhoto(Photo, Photo)
    case unableToSavePhoto
    case unableToGetPhotos
}

extension PhotoListError {
    var localizedMessage: String {
        switch self {
        case .loadRemotePhotoFailed:
            return LocalizableString.loadRemotePhotoFailed
        case .notPhotoAvailable:
            return "No photo is available"
        case .unableToDeletePhoto(let photo):
            return "Unable to delete the photo id: \(photo.id)"
        case .unableToSwapPhoto(let sourcePhoto, let destinationPhoto):
            return  "Unable to swap the photo id: \(sourcePhoto.id) with photo id \(destinationPhoto.id)"
        case .unableToSavePhoto:
            return "Unable to save the photo"
        case .unableToGetPhotos:
            return "Unable to get photos from storage"
        }
    }
}
