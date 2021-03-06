//
//  PhotoListError.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

enum PhotoListError: Error {
    case loadRemotePhotoFailed
    case noPhotoAvailable
    case unableToDeletePhoto(Photo)
    case unableToSavePhoto
    case unableToGetPhotosFromLocalRepository
}

extension PhotoListError {
    var localizedMessage: String {
        switch self {
        case .loadRemotePhotoFailed:
            return LocalizableString.loadRemotePhotoFailed
        case .noPhotoAvailable:
            return LocalizableString.noPhotoAvailable
        case .unableToDeletePhoto(let photo):
            return String(format: LocalizableString.unableToDeletePhoto, photo.id)
        case .unableToSavePhoto:
            return LocalizableString.unableToSavePhoto
        case .unableToGetPhotosFromLocalRepository:
            return LocalizableString.unableToGetPhotoFromRepository
        }
    }
}
