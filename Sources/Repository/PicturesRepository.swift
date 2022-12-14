//
//  PicturesRepository.swift
//  
//
//  Created by Grinch on 14/12/2022.
//

import Foundation
import Domain
import Combine

public class PicturesRepository: PicturesRepositoryProtocol {

    typealias Period = (startDate: Date, endDate: Date)

    // MARK: Private properties
    private let mediasRemoteStore: MediasRemoteStoreProtocol
    private let calendar = Calendar.current

    // MARK: Init
    public init(mediasRemoteStore: MediasRemoteStoreProtocol) {
        self.mediasRemoteStore = mediasRemoteStore
    }

    // MARK: PicturesRepositoryProtocol
    public func picturesFromLast(days: Int,
                                 since date: Date = Date()) -> AnyPublisher<[Picture], PicturesRepositoryError> {

        guard let period = try? prepareStartAndEndDates(for: days, since: date) else {
            return Fail(error: PicturesRepositoryError.invalidParameters).eraseToAnyPublisher()
        }
        return mediasRemoteStore
            .getMedias(from: period.startDate, to: period.endDate)
            .map { medias -> [Picture] in
                medias.compactMap { media -> Picture? in PictureMapper(media) }
            }.mapError(convert(_:))
            .eraseToAnyPublisher()
    }

    // MARK: Private methods
    private func convert(_ mediasRemoteStoreError: MediasRemoteStoreError) -> Domain.PicturesRepositoryError {
        switch mediasRemoteStoreError {
        case .invalidParameters: return .invalidParameters
        case .somethingWrong: return .somethingWrong
        }
    }

    private func prepareStartAndEndDates(for days: Int, since date: Date) throws -> Period  {
        guard let startDate = calendar.date(byAdding: .day, value: -days + 1, to: date) else {
            throw PicturesRepositoryError.invalidParameters
        }
        guard startDate <= date else {
            throw PicturesRepositoryError.invalidParameters
        }
        return (startDate: startDate, endDate: date)
    }
}
