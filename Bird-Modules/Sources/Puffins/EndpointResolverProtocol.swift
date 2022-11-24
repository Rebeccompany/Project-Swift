//
//  EndpointResolverProtocol.swift
//
//
//  Created by Rebecca Mello on 28/10/22.
//

import Foundation
import Combine

public protocol EndpointResolverProtocol {
    func dataTaskPublisher(for endpoint: Endpoint) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
    func dataTaskPublisher(for endpoint: Endpoint, authToken: String) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
}
