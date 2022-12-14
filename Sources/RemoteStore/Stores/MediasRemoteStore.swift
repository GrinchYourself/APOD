//
//  PicturesRemoteStore.swift
//  
//
//  Created by Grinch on 13/12/2022.
//

import Foundation
import Combine
import Domain

public class MediasRemoteStore: MediasRemoteStoreProtocol {

    private enum K {
        static let apiKey = "api_key"
        static let apiValue = "DEMO_KEY"
        static let startDateKey = "start_date"
        static let endDateKey = "end_date"
    }

    // MARK: Private properties
    private let httpDataProvider: HTTPDataProvider

    private var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }

    private var urlRequest: URLRequest = {
        let endpoint = URL(string: "https://api.nasa.gov/planetary/apod")!
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }()

    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()

    //MARK: Init
    public init(httpDataProvider: HTTPDataProvider) {
        self.httpDataProvider = httpDataProvider
    }
    
    public func getMedias(from startDate: Date, to endDate: Date) -> AnyPublisher<[Media], MediasRemoteStoreError> {
        guard startDate < endDate else {
            return Fail(error: MediasRemoteStoreError.invalidParameters).eraseToAnyPublisher()
        }

        addQueryItems(for: startDate, and: endDate)

        return httpDataProvider.dataPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: [MediaDTO].self, decoder: jsonDecoder)
            .map { mediasDTO -> [Domain.Media] in mediasDTO }
            .mapError { error in MediasRemoteStoreError.somethingWrong }
            .eraseToAnyPublisher()
    }

    // MARK: Private methods
    private func addQueryItems(for startDate: Date, and endDate: Date) {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: K.apiKey, value: K.apiValue))
        queryItems.append(URLQueryItem(name: K.startDateKey, value: dateFormatter.string(from: startDate)))
        queryItems.append(URLQueryItem(name: K.endDateKey, value: dateFormatter.string(from: endDate)))

        urlRequest.url?.append(queryItems: queryItems)
    }
}

