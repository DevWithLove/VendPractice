//
//  PhotoApi.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

import Foundation

enum PhotoApi {
    
    private enum Constants: String {
        case baseUrl = "https://picsum.photos/"
        case version = "v2"
        case listSub = "/list"
        case defaultContentType = "application/json"
        case contentTypeHeaderKey = "Content-Type"
    }
    
    // MARK: - API subs
    case getList
    
    private var full: String {
        let base = "\(Constants.baseUrl.rawValue)\(Constants.version.rawValue)"
        switch self {
        case .getList:
            return "\(base)\(Constants.listSub.rawValue)"
        }
    }
    
    private var method: HttpMethod {
        switch self {
        case .getList: return .get
        }
    }
    
    private var contentType: String {
        switch self {
        default: return Constants.defaultContentType.rawValue
        }
    }
    
    func request(withBody body: Data? = nil) throws -> URLRequest {
        guard let url = URL(string: full) else { throw ApiError.urlError("Invalid url:\(full)") }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue(contentType, forHTTPHeaderField: Constants.contentTypeHeaderKey.rawValue)
        request.httpBody = body
        return request
    }

}

enum HttpMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
    
    var lowercased: String {
        return rawValue.lowercased()
    }
}

enum ApiError: Error {
    case urlError(String)
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodingError
    case encodingError
    case unknown(Error)
}
