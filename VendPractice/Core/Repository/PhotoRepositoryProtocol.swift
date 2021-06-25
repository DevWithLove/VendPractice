//
//  PhotoRepositoryProtocol.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

import Foundation

protocol PhotoRepositoryProtocol {
    func get() throws -> [Photo]
    func save(_ photo: Photo) throws
    func delete(_ photo: Photo) throws
}

