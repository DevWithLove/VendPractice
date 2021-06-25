//
//  URLRequestExtensions.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

import Foundation

extension HTTPURLResponse {
    static let successResponseCodeRange = 200..<299
    
    var isValidResponse: Bool {
        return HTTPURLResponse.successResponseCodeRange ~= statusCode
    }
}

extension URLRequest {
    var session: URLSession {
        return URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func send<T: Decodable>(completion: @escaping (Result<T, ApiError>) -> Void) {
        session.dataTask(with: self) { (data, response, error) in
            if let error = error {
                completion(.failure(ApiError.unknown(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.isValidResponse, let data = data else {
                completion(.failure(ApiError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let values = try decoder.decode(T.self, from: data)
                completion(.success(values))
            } catch {
                completion(.failure(ApiError.decodingError))
            }
        }.resume()
    }
}
