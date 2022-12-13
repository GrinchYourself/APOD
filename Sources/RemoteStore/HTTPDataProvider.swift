//
//  HTTPDataProvider.swift
//
//
//  Created by Grinch on 06/11/2022.
//

import Foundation
import Combine

public protocol HTTPDataProvider {
    typealias HTTPResponse = URLSession.DataTaskPublisher.Output
    
    func dataPublisher(for request: URLRequest) -> AnyPublisher<HTTPResponse, URLError>
}
