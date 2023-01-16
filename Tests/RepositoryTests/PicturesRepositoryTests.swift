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

    // MARK: Get Pictures
    func testSuccessGetPicturesListing() {
        let remoteStore = MockMediasRemoteStoreProtocol()

        let picturesRepository = PicturesRepository(mediasRemoteStore: remoteStore)

        let expectation = XCTestExpectation(description: "get Listing Pictures success")
        let date = dateFormatter.date(from: "12/12/2022")!

        picturesRepository.picturesFromLastDays(count: 2, since: date).sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Failure not expected")
            }
        } receiveValue: { pictures in
            XCTAssertEqual(2, pictures.count)
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    func testSuccessGetPicturesListingWithRecursiveCalls() {
        let remoteStore = MockMediasRemoteStoreProtocol()

        let picturesRepository = PicturesRepository(mediasRemoteStore: remoteStore)

        let expectation = XCTestExpectation(description: "get Listing Pictures success with recursive calls")
        let date = dateFormatter.date(from: "12/12/2022")!

        picturesRepository.picturesFromLastDays(count: 3, since: date).sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Failure not expected")
            }
        } receiveValue: { pictures in
            XCTAssertEqual(3, pictures.count)
            //Check order of pictures
            XCTAssertTrue(pictures[0].date > pictures[1].date)
            XCTAssertTrue(pictures[1].date > pictures[2].date)
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureGetPicturesListingInvalidParametersFromRemoteStore() {
        let remoteStore = MockMediasRemoteStoreProtocol(error: .invalidParameters)

        let picturesRepository = PicturesRepository(mediasRemoteStore: remoteStore)

        let expectation = XCTestExpectation(description: "get Listing Pictures failure invalidParameters")
        let date = dateFormatter.date(from: "12/12/2022")!

        picturesRepository.picturesFromLastDays(count: 5, since: date).sink { completion in
            switch completion {
            case .finished:
                XCTFail("Failure not expected")

            case .failure(let error):
                switch error {
                case .invalidParameters:
                    expectation.fulfill()
                case .somethingWrong:
                    XCTFail("somethingWrong error not expected")
                case .unknownPicture:
                    XCTFail("unknownPicture error not expected")
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

        picturesRepository.picturesFromLastDays(count: 5, since: date).sink { completion in
            switch completion {
            case .finished:
                XCTFail("Failure not expected")

            case .failure(let error):
                switch error {
                case .invalidParameters:
                    XCTFail("invalidParameters error not expected")
                case .somethingWrong:
                    expectation.fulfill()
                case .unknownPicture:
                    XCTFail("unknownPicture error not expected")
                }
            }
        } receiveValue: { _ in
            XCTFail("received values not expected")
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: Period
    func testMakePeriod() {
        let remoteStore = MockMediasRemoteStoreProtocol(error: .somethingWrong)
        let picturesRepository = PicturesRepository(mediasRemoteStore: remoteStore)

        let december13 = dateFormatter.date(from: "13/12/2022")!
        let december12 = dateFormatter.date(from: "12/12/2022")!
        let december11 = dateFormatter.date(from: "11/12/2022")!
        let december10 = dateFormatter.date(from: "10/12/2022")!
        let december09 = dateFormatter.date(from: "09/12/2022")!
        let december08 = dateFormatter.date(from: "08/12/2022")!
        let december07 = dateFormatter.date(from: "07/12/2022")!

        do {
            picturesRepository.preparePeriodForDays(count: 5, since: december12)
            let period = try XCTUnwrap(picturesRepository.period)
            let dateRange = (period.startDate...period.endDate)
            XCTAssertTrue(dateRange.contains(december12))
            XCTAssertTrue(dateRange.contains(december11))
            XCTAssertTrue(dateRange.contains(december10))
            XCTAssertTrue(dateRange.contains(december09))
            XCTAssertTrue(dateRange.contains(december08))
            XCTAssertFalse(dateRange.contains(december07))
            XCTAssertFalse(dateRange.contains(december13))
        } catch {
            XCTFail("can not create a Period")
        }

        let march03 = dateFormatter.date(from: "03/03/2024")!
        let march02 = dateFormatter.date(from: "02/03/2024")!
        let march01 = dateFormatter.date(from: "01/03/2024")!
        let february29 = dateFormatter.date(from: "29/02/2024")!
        let february28 = dateFormatter.date(from: "28/02/2024")!
        let february27 = dateFormatter.date(from: "27/02/2024")!

        do {
            picturesRepository.preparePeriodForDays(count: 4, since: march02)
            let period = try XCTUnwrap(picturesRepository.period)
            let dateRange = (period.startDate...period.endDate)
            XCTAssertTrue(dateRange.contains(march02))
            XCTAssertTrue(dateRange.contains(march01))
            XCTAssertTrue(dateRange.contains(february29))
            XCTAssertTrue(dateRange.contains(february28))
            XCTAssertFalse(dateRange.contains(february27))
            XCTAssertFalse(dateRange.contains(march03))
        } catch {
            XCTFail("can not create a Period")
        }

    }

    // MARK: Mock
    class MockMediasRemoteStoreProtocol: MediasRemoteStoreProtocol {

        let error: MediasRemoteStoreError?
        var requestCount = 0
        let mockMediaRequest1 = Array(Mocks().medias[0...2])
        let mockMediaRequest2 = [Mocks().medias[3]]
        let mockMediaRequest3 = [Mocks().medias[4]]

        init(error: MediasRemoteStoreError? = nil) {
            self.error = error
        }

        func getMedias(from startDate: Date, to endDate: Date) -> AnyPublisher<[Domain.Media], Domain.MediasRemoteStoreError> {
            requestCount += 1
            switch error {
            case .none:
                switch requestCount {
                case 1:
                    return Just(mockMediaRequest1).setFailureType(to: MediasRemoteStoreError.self).eraseToAnyPublisher()
                case 2:
                    return Just(mockMediaRequest2).setFailureType(to: MediasRemoteStoreError.self).eraseToAnyPublisher()
                default:
                    return Just(mockMediaRequest3).setFailureType(to: MediasRemoteStoreError.self).eraseToAnyPublisher()
                }
            case .some(let mediasRemoteStoreError):
                return Fail(error: mediasRemoteStoreError).eraseToAnyPublisher()
            }
        }
    }
}
