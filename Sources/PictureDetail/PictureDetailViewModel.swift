//
//  PictureDetailViewModel.swift
//  
//
//  Created by Grinch on 17/12/2022.
//

import Foundation
import Domain
import Combine

struct PictureDetail {
    let title: String
    let date: String?
    let explantion: String
    let pictureURL: URL?
    let copyright: String?
    let highDefinitionURL: URL?
}

enum PictureDetailViewModelingError: Error {
    case unknownPicture
}

protocol PictureDetailViewModeling {

    var detailPublisher: AnyPublisher<PictureDetail, PictureDetailViewModelingError> { get }

    func fetchPictureDetail() -> AnyPublisher<Void, Never>
}

class PictureDetailViewModel: PictureDetailViewModeling {

    typealias Dependencies = HasPicturesRepository

    // MARK: Public properties
    lazy var detailPublisher = {
        pictureSubject.eraseToAnyPublisher()
    }()

    // MARK: Private properties
    private let pictureSubject = PassthroughSubject<PictureDetail, PictureDetailViewModelingError>()
    private var picture: Picture?

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    //MARK: Init
    init(dependencies: Dependencies, pictureId id: String) {
        picture = try? dependencies.picturesRepository.picture(id: id)
    }

    // MARK: Public methods
    func fetchPictureDetail() -> AnyPublisher<Void, Never> {
        guard let picture else {
            pictureSubject.send(completion: .failure(.unknownPicture))
            return Just(()).eraseToAnyPublisher()
        }
        let detail = makePictureDetail(from: picture)
        pictureSubject.send(detail)
        pictureSubject.send(completion: .finished)
        return Just(()).eraseToAnyPublisher()
    }

    private func makePictureDetail(from picture: Picture) -> PictureDetail {
        PictureDetail(title: picture.title,
                      date: dateFormatter.string(from: picture.date),
                      explantion: picture.explanation,
                      pictureURL: picture.url.standard,
                      copyright: picture.copyright,
                      highDefinitionURL: picture.url.high)
    }
}
