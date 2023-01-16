//
//  ImageLoader.swift
//  
//
//  Created by Grinch on 16/12/2022.
//

import Combine
import Foundation
import UIKit

public enum ImageLoadingError: Error {
    case somethingWrong
}

public protocol HasImageLoader {
    var imageLoader: ImageLoading { get }
}

public protocol ImageLoading {
    func loadImage(for url: URL) -> AnyPublisher<UIImage, ImageLoadingError>
}
