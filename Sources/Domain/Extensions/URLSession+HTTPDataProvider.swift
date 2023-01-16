//
//  URLSession + HTTPDataProvider.swift
//
//
//  Created by Grinch on 16/12/2022.
//

import Combine
import Foundation

extension URLSession: HTTPDataProvider {

    public func dataPublisher(for request: URLRequest) -> AnyPublisher<HTTPResponse, URLError> {
        dataTaskPublisher(for: request).eraseToAnyPublisher()
    }

    public func dataPublisher(for url: URL) -> AnyPublisher<HTTPResponse, URLError> {
        dataTaskPublisher(for: url).eraseToAnyPublisher()
    }

}
