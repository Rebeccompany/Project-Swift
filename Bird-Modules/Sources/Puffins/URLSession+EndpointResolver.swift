//
//  URLSession+EndpointResolver.swift
//
//
//  Created by Rebecca Mello on 28/10/22.
//

import Foundation
import Combine

extension URLSession: EndpointResolverProtocol {
    public func dataTaskPublisher(for endpoint: Endpoint, authToken: String) -> AnyPublisher<DataTaskPublisher.Output, DataTaskPublisher.Failure> {
        self.dataTaskPublisher(for: endpoint.authorizedRequest(token: authToken)).eraseToAnyPublisher()
    }
    
    public func dataTaskPublisher(for endpoint: Endpoint) -> AnyPublisher<DataTaskPublisher.Output, DataTaskPublisher.Failure> {
        self.dataTaskPublisher(for: endpoint.request).eraseToAnyPublisher()
    }
}
