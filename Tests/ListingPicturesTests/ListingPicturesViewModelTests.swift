//
//  ListingPicturesViewModelTests.swift
//  
//
//  Created by Grinch on 16/12/2022.
//

import XCTest
import Combine
import Domain
@testable import ListingPictures

final class ListingPicturesViewModelTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        cancellables.removeAll()
        continueAfterFailure = true
    }

    override func tearDown() {
        super.tearDown()
        cancellables.removeAll()
    }

    func testSuccessFetchingPicturesListing() {
        let mockDependencies = MockDependencies(isSuccess: true)
        let viewModel = ListingPicturesViewModel(dependencies: mockDependencies)

        let expectation = XCTestExpectation(description: "Get fetch Pictures Listing Success")
        expectation.expectedFulfillmentCount = 2
        
        viewModel.picturesListPublisher
            .dropFirst() // Drop inital empty state
            .sink { pictures in
                XCTAssertEqual(5, pictures.count)
                expectation.fulfill()
            }.store(in: &cancellables)

        var stateChangesCount = 0
        viewModel.fetchStatePublisher.sink { fetchState in
            switch stateChangesCount {
            case 0: XCTAssertEqual(.none, fetchState)
            case 1: XCTAssertEqual(.success, fetchState)
            default: XCTFail("Not expected")
            }
            stateChangesCount += 1
        }.store(in: &cancellables)

        viewModel.fetchPictures().sink { _ in
            expectation.fulfill()
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 0.2)

    }

    func testFailureFetchingPicturesListing() {
        let mockDependencies = MockDependencies(isSuccess: false)
        let viewModel = ListingPicturesViewModel(dependencies: mockDependencies)

        let expectation = XCTestExpectation(description: "Get fetch Pictures Listing Failure")
        viewModel.picturesListPublisher
            .dropFirst() // Drop initial empty state
            .sink { pictures in
                XCTFail("Not expected")
            }.store(in: &cancellables)

        var stateChangesCount = 0
        viewModel.fetchStatePublisher.sink { fetchState in
            switch stateChangesCount {
            case 0: XCTAssertEqual(.none, fetchState)
            case 1: XCTAssertEqual(.error, fetchState)
            default: XCTFail("Not expected")
            }
            stateChangesCount += 1
        }.store(in: &cancellables)

        viewModel.fetchPictures().sink { _ in
            expectation.fulfill()
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 0.2)
    }

    // MARK: MOCK
    struct MockDependencies: ListingPicturesViewModel.Dependencies {
        let picturesRepository: Domain.PicturesRepositoryProtocol

        init(isSuccess: Bool) {
            picturesRepository = MockPicturesRepository(isSuccess: isSuccess)
        }
    }

    struct MockPicturesRepository: PicturesRepositoryProtocol {

        let isSuccess: Bool
        let mocks = Mocks()

        init(isSuccess: Bool) {
            self.isSuccess = isSuccess
        }

        func picturesFromLastDays(count: UInt, since: Date) -> AnyPublisher<[Picture], PicturesRepositoryError> {
            if isSuccess {
                return Just(mocks.pictures).setFailureType(to: PicturesRepositoryError.self).eraseToAnyPublisher()
            } else {
                return Fail(error: PicturesRepositoryError.somethingWrong).eraseToAnyPublisher()
            }
        }
    }
}
