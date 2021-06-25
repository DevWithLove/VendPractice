//
//  PhotoDto.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

import Foundation

struct PhotoDto: Decodable {
    let id: String?
    let author: String?
    let width: Int?
    let height: Int?
    let url: String?
    let downloadUrl: String?
}
