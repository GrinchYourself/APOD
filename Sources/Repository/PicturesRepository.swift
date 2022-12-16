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

    var period: Period?

    // MARK: Private properties
    private let mediasRemoteStore: MediasRemoteStoreProtocol
    private let calendar = Calendar.current

    private var pictures = [PictureMapper]()
    private var isRequesting = false

    // MARK: Init
    public init(mediasRemoteStore: MediasRemoteStoreProtocol) {
        self.mediasRemoteStore = mediasRemoteStore
    }

    // MARK: PicturesRepositoryProtocol
    public func picturesFromLastDays(count: UInt,
                                     since date: Date = Date()) -> AnyPublisher<[Picture], PicturesRepositoryError> {

        initializeRequestIfNeeded()
        preparePeriodForDays(count: count, since: date)

        return filterPicturesFromMediaPublisher()
            .handleEvents(receiveOutput: save(pictures:))
            .flatMap { [weak self] requestPictures -> AnyPublisher<[Picture], PicturesRepositoryError> in
                guard let self else {
                    return Empty().setFailureType(to: PicturesRepositoryError.self).eraseToAnyPublisher()
                }
                return self.checkPicturesCount(requestPictures, count: count)
            }
            .eraseToAnyPublisher()
    }

    func preparePeriodForDays(count: UInt, since date: Date) {
        guard let startDate = calendar.date(byAdding: .day, value: -Int(count) + 1, to: date) else {
            period = nil
            return
        }
        guard startDate <= date else {
            period = nil
            return
        }
        period = (startDate: startDate, endDate: date)
    }

    // MARK: Private methods
    private func convert(_ mediasRemoteStoreError: MediasRemoteStoreError) -> Domain.PicturesRepositoryError {
        switch mediasRemoteStoreError {
        case .invalidParameters: return .invalidParameters
        case .somethingWrong: return .somethingWrong
        }
    }

    private func initializeRequestIfNeeded() {

        if !isRequesting {
            isRequesting = true
            pictures.removeAll()
        }
        
    }

    private func filterPicturesFromMediaPublisher() -> AnyPublisher<[PictureMapper], PicturesRepositoryError> {

        guard let period else {
            return Fail(error: PicturesRepositoryError.invalidParameters).eraseToAnyPublisher()
        }

        return mediasRemoteStore
            .getMedias(from: period.startDate, to: period.endDate)
            .map { medias -> [PictureMapper] in
                medias.compactMap { media -> PictureMapper? in PictureMapper(media) }
            }
            .mapError(convert(_:))
            .eraseToAnyPublisher()
    }

    private func checkPicturesCount(_ requestPictures: [PictureMapper],
                                    count: UInt) -> AnyPublisher<[Picture], PicturesRepositoryError> {

        guard requestPictures.count != count else {
            return Just(pictures).setFailureType(to: PicturesRepositoryError.self).eraseToAnyPublisher()
        }
        guard let period else {
            return Fail(error: PicturesRepositoryError.invalidParameters).eraseToAnyPublisher()
        }
        guard let date = calendar.date(byAdding: .day, value: -1, to: period.startDate) else {
            return Fail(error: PicturesRepositoryError.invalidParameters).eraseToAnyPublisher()
        }

        let leftPicturesCount = count - UInt(requestPictures.count)
        return picturesFromLastDays(count: leftPicturesCount, since: date)

    }

    private func save(pictures requestPictures: [PictureMapper]) {
        pictures.append(contentsOf: requestPictures)
    }

}
