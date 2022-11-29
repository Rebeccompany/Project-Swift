//
//  Publisher+EndpointUtils.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 25/11/22.
//

import Foundation
import Combine

extension Publisher where Output == URLSession.DataTaskPublisher.Output, Failure == URLSession.DataTaskPublisher.Failure {
    
    func verifySuccess() -> some Publisher<Data, Failure> {
        self
            .tryMap { data, response in
                let range = 200...299
                guard let response = response as? HTTPURLResponse,
                      range.contains(response.statusCode)
                else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .mapError { error in
                if let error = error as? URLError {
                    return error
                } else {
                    return URLError(.cannotDecodeContentData)
                }
            }
    }
    
    func verifyVoidSuccess() -> some Publisher<Void, Failure> {
        self
            .tryMap { _, response in
                let range = 200...299
                guard let response = response as? HTTPURLResponse,
                      range.contains(response.statusCode)
                else {
                    throw URLError(.badServerResponse)
                }
                return Void()
            }
            .mapError { error in
                if let error = error as? URLError {
                    return error
                } else {
                    return URLError(.cannotDecodeContentData)
                }
            }
    }
    
    func decodeWhenSuccess<T: Decodable>(to type: T.Type) -> some Publisher<T, URLError> {
        self
            .verifySuccess()
            .decode(type: type, decoder: JSONDecoder())
            .mapToURLError()
    }
}

extension Publisher {
    func mapToURLError() -> some Publisher<Output, URLError> {
        self
            .mapError { error in
                if let error = error as? URLError {
                    return error
                } else {
                    return URLError(.cannotDecodeContentData)
                }
            }
    }
}
