//
//  PicturesRepositoryTests.swift
//  
//
//  Created by Grinch on 14/12/2022.
//

import XCTest
import Domain
import Combine
@testable import Repository

final class PicturesRepositoryTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter
    }()

    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        cancellables.removeAll()
    }

    override func tearDown() {
        cancellables.removeAll()
    }

    func testSuccessGetPicturesListing() {
        let remoteStore = MockMediasRemoteStoreProtocol()

        let picturesRepository = PicturesRepository(mediasRemoteStore: remoteStore)

        let expectation = XCTestExpectation(description: "get Listing Pictures success")
        let date = dateFormatter.date(from: "12/12/2022")!

        picturesRepository.picturesFromLast(days: 5, since: date).sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Failure not expected")
            }
        } receiveValue: { pictures in
            XCTAssertEqual(3, pictures.count)
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureGetPicturesListingBadParametersFromPeriod() {
        let remoteStore = MockMediasRemoteStoreProtocol()

        let picturesRepository = PicturesRepository(mediasRemoteStore: remoteStore)

        let expectation = XCTestExpectation(description: "get Listing Pictures success")
        let date = dateFormatter.date(from: "12/12/2022")!

        picturesRepository.picturesFromLast(days: -5, since: date).sink { completion in
            switch completion {
            case .finished:
                XCTFail("Success not expected")
            case .failure(let error):
                switch error {
                case .invalidParameters:
                    expectation.fulfill()
                case .somethingWrong:
                    XCTFail("somethingWrong error not expected")
                }
            }
        } receiveValue: { pictures in
            XCTFail("receive value not expected")
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureGetPicturesListingInvalidParametersFromRemoteStore() {
        let remoteStore = MockMediasRemoteStoreProtocol(error: .invalidParameters)

        let picturesRepository = PicturesRepository(mediasRemoteStore: remoteStore)

        let expectation = XCTestExpectation(description: "get Listing Pictures failure invalidParameters")
        let date = dateFormatter.date(from: "12/12/2022")!

        picturesRepository.picturesFromLast(days: 5, since: date).sink { completion in
            switch completion {
            case .finished:
                XCTFail("Failure not expected")

            case .failure(let error):
                switch error {
                case .invalidParameters:
                    expectation.fulfill()
                case .somethingWrong:
                    XCTFail("somethingWrong error not expected")
                }
            }
        } receiveValue: { _ in
            XCTFail("received values not expected")
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureGetPicturesListingSomethingWrongFromRemoteStore() {
        let remoteStore = MockMediasRemoteStoreProtocol(error: .somethingWrong)

        let picturesRepository = PicturesRepository(mediasRemoteStore: remoteStore)

        let expectation = XCTestExpectation(description: "get Listing Pictures failure somethingWrong")
        let date = dateFormatter.date(from: "12/12/2022")!

        picturesRepository.picturesFromLast(days: 5, since: date).sink { completion in
            switch completion {
            case .finished:
                XCTFail("Failure not expected")

            case .failure(let error):
                switch error {
                case .invalidParameters:
                    XCTFail("invalidParameters error not expected")
                case .somethingWrong:
                    expectation.fulfill()
                }
            }
        } receiveValue: { _ in
            XCTFail("received values not expected")
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: Mock
    class MockMediasRemoteStoreProtocol: MediasRemoteStoreProtocol {

        let error: MediasRemoteStoreError?

        init(error: MediasRemoteStoreError? = nil) {
            self.error = error
        }

        func getMedias(from startDate: Date, to endDate: Date) -> AnyPublisher<[Domain.Media], Domain.MediasRemoteStoreError> {
            switch error {
            case .none:
                return Just(Mocks().medias).setFailureType(to: MediasRemoteStoreError.self).eraseToAnyPublisher()
            case .some(let mediasRemoteStoreError):
                return Fail(error: mediasRemoteStoreError).eraseToAnyPublisher()
            }
        }
    }
}
