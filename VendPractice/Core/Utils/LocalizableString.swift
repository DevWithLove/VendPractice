//
//  LocalizableString.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

import Foundation

class LocalizableString: NSObject {
    // MARK: Photos
    static var photoListTitle = NSLocalizedString("PHOTO_LIST_TITLE", comment: "Photos view")
    static var buttonAdd = NSLocalizedString("BUTTON_ADD", comment: "Photos view")
    static var buttonOk = NSLocalizedString("BUTTON_OK", comment: "Photos view")
    static var buttonEdit = NSLocalizedString("BUTTON_EDIT", comment: "Photos view")
    static var buttonReload = NSLocalizedString("BUTTON_RELOAD", comment: "Photos view")
    static var loadRemotePhotoFailed = NSLocalizedString("LOAD_REMOTE_PHOTO_FAILED_MESSAGE", comment: "Photos view")
    static var noPhotoAvailable = NSLocalizedString("NO_PHOTO_AVAILABLE", comment: "Photos view")
    static var unableToDeletePhoto = NSLocalizedString("UNABLE_TO_DELETE_PHOTO", comment: "Photos view")
    static var unableToSavePhoto = NSLocalizedString("UNABLE_TO_SAVE_PHOTO", comment: "Photos view")
    static var unableToGetPhotoFromRepository = NSLocalizedString("UNABLE_TO_GET_PHOTO_FROM_LOCAL_REPOSITORY", comment: "Photos view")

}
