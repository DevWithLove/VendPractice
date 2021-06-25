//
//  PhotoWebService.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

import Foundation

protocol PhotoWebServiceProtocol {
    func getPhotos(completion: @escaping (Result<[PhotoDto]?, ApiError>)-> Void)
}

class PhotoWebService: PhotoWebServiceProtocol {
    func getPhotos(completion: @escaping (Result<[PhotoDto]?, ApiError>) -> Void) {
        do {
            let request = try PhotoApi.getList.request()
            request.send(completion: completion)
        } catch {
            completion(.failure(.unknown(error)))
        }
    }
}
