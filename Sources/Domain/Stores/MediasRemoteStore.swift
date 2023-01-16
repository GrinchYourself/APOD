//
//  MediasRemoteStore.swift
//  
//
//  Created by Grinch on 14/12/2022.
//

import Foundation
import Combine

public enum MediasRemoteStoreError: Error {
    case invalidParameters
    case somethingWrong
}

public protocol HasMediasRemoteStore {
    var mediasRemoteStore: MediasRemoteStoreProtocol { get }
}

public protocol MediasRemoteStoreProtocol {
    func getMedias(from startDate: Date, to endDate: Date) -> AnyPublisher<[Media], MediasRemoteStoreError>
}
