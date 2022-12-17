//
//  PictureDetailViewModelTests.swift
//  
//
//  Created by Grinch on 17/12/2022.
//

import XCTest
import Combine
import Domain
@testable import PictureDetail

final class PictureDetailViewModelTests: XCTestCase {

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

    func testSuccessGetDetail() {
        let mockDependencies = MockDependencies(isSuccess: true)
        let viewModel = PictureDetailViewModel(dependencies: mockDependencies, pictureId: "pictureID")

        let detailExpectation = XCTestExpectation(description: "Success detailPublisher expectation")
        let fetchExpectation = XCTestExpectation(description: "Success fetch expectation")

        viewModel.detailPublisher.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                detailExpectation.fulfill()
            case .failure:
                XCTFail("failure not expected")
            }
        }, receiveValue: { pictureDetail in
            XCTAssertEqual("Pillars of Creation", pictureDetail.title)
        })
        .store(in: &cancellables)

        viewModel.fetchPictureDetail().sink { _ in
            fetchExpectation.fulfill()
        }.store(in: &cancellables)
        wait(for: [fetchExpectation, detailExpectation], timeout: 0.2)

    }

    func testFailureGetDetail() {
        let mockDependencies = MockDependencies(isSuccess: false)
        let viewModel = PictureDetailViewModel(dependencies: mockDependencies, pictureId: "pictureID")

        let detailExpectation = XCTestExpectation(description: "Failure detailPublisher expectation")
        let fetchExpectation = XCTestExpectation(description: "Failure fetch expectation")

        viewModel.detailPublisher.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTFail("failure not expected")
            case .failure:
                detailExpectation.fulfill()
            }
        }, receiveValue: { pictureDetail in
            XCTFail("receive value not expected")
        })
        .store(in: &cancellables)

        viewModel.fetchPictureDetail().sink { _ in
            fetchExpectation.fulfill()
        }.store(in: &cancellables)
        wait(for: [fetchExpectation, detailExpectation], timeout: 0.2)

    }

    // MARK: MOCK
    struct MockDependencies: PictureDetailViewModel.Dependencies {
        let picturesRepository: Domain.PicturesRepositoryProtocol

        init(isSuccess: Bool) {
            picturesRepository = MockPicturesRepository(isSuccess: isSuccess)
        }
    }

    struct MockPicturesRepository: PicturesRepositoryProtocol {

        let isSuccess: Bool

        private var dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
            return dateFormatter
        }()

        init(isSuccess: Bool) {
            self.isSuccess = isSuccess
        }

        func picture(id: String) throws -> Domain.Picture {
            if isSuccess {
                return MockPicture(id: "stsci-pillarsofcreation1280c",
                                   date: dateFormatter.date(from: "19/10/2022")!,
                                   title: "Pillars of Creation",
                                   explanation: "A now famous picture from the Hubble Space Telescope featured these star",
                                   copyright: nil,
                                   url: MockPicturesURL(standard: URL(string: "https://apod.nasa.gov/apod/image/2210/stsci-pillarsofcreation1280c.jpg"),
                                                        high: URL(string: "https://apod.nasa.gov/apod/image/2210/stsci-pillarsofcreation.png")))
            } else {
                throw PicturesRepositoryError.unknownPicture }
        }

        // Not used
        func picturesFromLastDays(count: UInt, since: Date) -> AnyPublisher<[Picture], PicturesRepositoryError> {
            Just([]).setFailureType(to: PicturesRepositoryError.self).eraseToAnyPublisher()
        }

    }

    struct MockPicture: Picture {
        let id: String
        let date: Date
        let title: String
        let explanation: String
        let copyright: String?
        let url: Domain.PicturesURL
    }

    struct MockPicturesURL: PicturesURL {
        let standard: URL?
        let high: URL?
    }

}
