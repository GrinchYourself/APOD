//
//  ImageLoader.swift
//  PaperClipApp
//
//  Created by Grinch on 13/11/2022.
//

import Foundation
import Combine
import UIKit
import Domain

public enum ImageLoadingError: Error {
    case somethingWrong
}

public protocol ImageLoading {
    func loadImage(for url: URL) -> AnyPublisher<UIImage, ImageLoadingError>
}

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
