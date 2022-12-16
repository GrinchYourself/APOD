//
//  RemoteStoreTests.swift
//  
//
//  Created by Grinch on 13/12/2022.
//

import XCTest
import Combine
import Foundation
import Domain
@testable import RemoteStore

final class RemoteStoresTests: XCTestCase {

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

    func testSuccessGetMediasListing() {
        let dependencies = MockHTTPDataProvider(status: .mediasSuccess)
        let remoteStore = MediasRemoteStore(httpDataProvider: dependencies)
        
        let expectation = XCTestExpectation(description: "get Listing Medias success")
        let startDate = dateFormatter.date(from: "01/11/2022")!
        let endDate = dateFormatter.date(from: "12/12/2022")!

        remoteStore.getMedias(from: startDate, to: endDate).sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Failure not expected")
            }
        } receiveValue: { medias in
            XCTAssertEqual(42, medias.count)
            XCTAssertEqual(39, medias.filter({ $0.media == .image }).count)
            XCTAssertEqual(3, medias.filter({ $0.media == .video }).count)

        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    func testSuccessGetOneMedia() {
        let dependencies = MockHTTPDataProvider(status: .oneMediaSuccess)
        let remoteStore = MediasRemoteStore(httpDataProvider: dependencies)

        let expectation = XCTestExpectation(description: "get One Media success")
        let startDate = dateFormatter.date(from: "01/11/2022")!
        let endDate = startDate

        remoteStore.getMedias(from: startDate, to: endDate).sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Failure not expected")
            }
        } receiveValue: { medias in
            XCTAssertEqual(1, medias.count)
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureGetMediasListingBadParameters() {
        let dependencies = MockHTTPDataProvider(status: .mediasSuccess)
        let remoteStore = MediasRemoteStore(httpDataProvider: dependencies)

        let expectation = XCTestExpectation(description: "get Listing Medias failure")
        let startDate = dateFormatter.date(from: "12/12/2022")!
        let endDate = dateFormatter.date(from: "01/11/2022")!

        remoteStore.getMedias(from: startDate, to: endDate).sink { completion in
            switch completion {
            case .finished:
                XCTFail("Success not expected")
            case .failure(let error):
                switch error {
                case .invalidParameters:
                    expectation.fulfill()
                case .somethingWrong:
                    XCTFail("somethingWrong Error not expected")
                }
            }
        } receiveValue: { medias in
            XCTFail("Receive Value not expected")

        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureGetMediasListingSomethingWrong() {
        let dependencies = MockHTTPDataProvider(status: .mediasFailure)
        let remoteStore = MediasRemoteStore(httpDataProvider: dependencies)

        let expectation = XCTestExpectation(description: "get Listing Medias failure")
        let startDate = dateFormatter.date(from: "01/11/2022")!
        let endDate = dateFormatter.date(from: "12/12/2022")!

        remoteStore.getMedias(from: startDate, to: endDate).sink { completion in
            switch completion {
            case .finished:
                XCTFail("Success not expected")
            case .failure(let error):
                switch error {
                case .invalidParameters:
                    XCTFail("invalidParameters Error not expected")
                case .somethingWrong:
                    expectation.fulfill()
                }
            }
        } receiveValue: { medias in
            XCTFail("Receive Value not expected")

        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: Mock
    class MockHTTPDataProvider: HTTPDataProvider {
        enum Status {
            case mediasSuccess
            case oneMediaSuccess
            case mediasFailure

            var resource: String {
                switch self {
                case .mediasSuccess:  return "ListingMedias"
                case .oneMediaSuccess: return "ListingOneMedia"
                case .mediasFailure:  return "BadListingMedias"
                }
            }
            
            var type: String {
                "json"
            }
        }
        
        let status: Status

        init(status: Status) {
            self.status = status
        }
        
        func dataPublisher(for request: URLRequest) -> AnyPublisher<HTTPResponse, URLError> {
            let url = Bundle.module.url(forResource: status.resource, withExtension: status.type, subdirectory: "Stub")!
            let data = try! Data(contentsOf: url)
            let response = URLResponse()
            return Just((data: data, response: response)).setFailureType(to: URLError.self).eraseToAnyPublisher()
        }

        // Not used
        func dataPublisher(for url: URL) -> AnyPublisher<HTTPResponse, URLError> {
            Empty().setFailureType(to: URLError.self).eraseToAnyPublisher()
        }

    }
}
