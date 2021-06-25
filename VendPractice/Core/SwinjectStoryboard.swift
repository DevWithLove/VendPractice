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
    }
}
