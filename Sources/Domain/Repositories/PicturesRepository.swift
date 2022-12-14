//
//  PicturesRepository.swift
//  
//
//  Created by Grinch on 14/12/2022.
//

import Foundation
import Combine

public enum PicturesRepositoryError: Error {
    case invalidParameters
    case somethingWrong
}

public protocol HasPicturesRepository {
    var picturesRepository: PicturesRepositoryProtocol { get }
}

public protocol PicturesRepositoryProtocol {
    func picturesFromLast(days: Int, since: Date) -> AnyPublisher<[Picture], PicturesRepositoryError>
}
