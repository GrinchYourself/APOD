//
//  ImageLoader.swift
//
//
//  Created by Grinch on 16/12/2022.
//

import Foundation
import Combine
import UIKit
import Domain

public class ImageLoader: ImageLoading {

    // MARK: shared
    public static let loader: ImageLoading = ImageLoader()

    // MARK: Private methods
    private let httpDataProvider: HTTPDataProvider

    // MARK: init
    init(httpDataProvider: HTTPDataProvider = URLSession.shared) {
        self.httpDataProvider = httpDataProvider
    }

    public func loadImage(for url: URL) -> AnyPublisher<UIImage, ImageLoadingError> {

        return httpDataProvider.dataPublisher(for: url)
            .map(\.data)
            .compactMap { UIImage(data: $0) }
            .mapError { _ in ImageLoadingError.somethingWrong }
            .eraseToAnyPublisher()

    }

}
