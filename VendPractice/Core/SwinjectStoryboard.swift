//
//  SwinjectStoryboard.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        defaultContainer.register(PhotoRepositoryProtocol.self) { _ in
            PhotoMemoryStorage()
        }
        defaultContainer.register(PhotoWebServiceProtocol.self) { _ in
            PhotoWebService()
        }
        defaultContainer.register(PhotoListViewModelProtocol.self) { r in
            PhotoListViewModel(photoWebService: r.resolve(PhotoWebServiceProtocol.self)!,
                               photoRepository: r.resolve(PhotoRepositoryProtocol.self)!)
        }
        defaultContainer.storyboardInitCompleted(PhotoViewController.self) { r, c in
            c.viewModel = r.resolve(PhotoListViewModelProtocol.self)!
        }
    }
}
