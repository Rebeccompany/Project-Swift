//
//  EndpointMock.swift
//  
//
//  Created by Rebecca Mello on 28/10/22.
//

import Foundation
import Combine
import Models

public final class EndpointResolverMock: EndpointResolverProtocol {
    
    
    
    
    var shouldThrowError: Bool = false
    var errorType: URLError?
    var data: Data?
    
    public func dataTaskPublisher(for endpoint: Endpoint) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        if shouldThrowError {
            return Fail<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>(error: errorType!).eraseToAnyPublisher()
        }
        
        let response = URLResponse(url: endpoint.url, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
        return Just((data: self.data!, response: response)).setFailureType(to: URLSession.DataTaskPublisher.Failure.self).eraseToAnyPublisher()
    }
    
    public func dataTaskPublisher(for endpoint: Endpoint, authToken: String) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        dataTaskPublisher(for: endpoint)
    }
    
    public func dataTaskPublisher(for endpoint: Endpoint, data: Data?) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        fatalError()
    }
    
    public var externalSection: [ExternalSection] = [
        ExternalSection(title: getCategoryString(category: .stem), decks: [ExternalDeck(id: "1", name: "Stem 1", description: "Stem Desc", icon: .chart, color: .red, category: .stem), ExternalDeck(id: "2", name: "Stem 2", description: "Stem Desc 2", icon: .abc, color: .darkBlue, category: .stem), ExternalDeck(id: "3", name: "Stem 3", description: "Stem Desc 3", icon: .atom, color: .gray, category: .stem)])
    ]
    
    public var externalSectionData: Data? {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(externalSection)
        return data
    }
    
}
