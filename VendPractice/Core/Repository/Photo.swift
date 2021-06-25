//
//  Photo.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

import Foundation

class Photo: Hashable {
    let id: String
    let author: String
    let downloadUrl: String
    var displayOrder: Int
    
    init(id: String, author: String, downloadUrl: String, displayOrder: Int) {
        self.id = id
        self.author = author
        self.downloadUrl = downloadUrl
        self.displayOrder = displayOrder
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Photo {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}
