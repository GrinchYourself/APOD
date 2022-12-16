//
//  ListingPicturesViewModel.swift
//  
//
//  Created by Grinch on 16/12/2022.
//

import Foundation
import Domain
import Combine

enum FetchState {
    case none
    case success
    case error
}

protocol ListingPicturesViewModeling {

    func fetchPictures() -> AnyPublisher<Void, Never>

    var picturesListPublisher: Published<[PictureThumbnail]>.Publisher { get }
    var fetchStatePublisher: Published<FetchState>.Publisher { get }

}

class ListingPicturesViewModel: ListingPicturesViewModeling {

    typealias Dependencies = HasPicturesRepository

    private enum K {
        static let picturesCount: UInt = 30
    }

    // MARK: Public properties
    var picturesListPublisher: Published<[PictureThumbnail]>.Publisher { $picturesList }
    var fetchStatePublisher: Published<FetchState>.Publisher { $fetchState }

    // MARK: Private properties
    private let picturesRepository: PicturesRepositoryProtocol
    @Published private var picturesList: [PictureThumbnail] = []
    @Published private var fetchState: FetchState = .none

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    //MARK: Init
    init(dependencies: Dependencies) {
        self.picturesRepository = dependencies.picturesRepository
    }

    // MARK: Public methods
    func fetchPictures() -> AnyPublisher<Void, Never> {
        picturesRepository
            .picturesFromLastDays(count: K.picturesCount, since: Date())
            .map({ pictures -> [PictureThumbnail] in
                pictures.map { PictureThumbnail($0, dateFormatter: Self.dateFormatter) }
            })
            .map { [weak self] pictures -> Void in
                self?.picturesList = pictures
                self?.fetchState = .success
            }.catch { [weak self] _ -> Just<Void> in
                self?.fetchState = .error
                return Just(())
            }.eraseToAnyPublisher()
    }

}
