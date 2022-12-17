//
//  Coordinator.swift
//  ApodApp
//
//  Created by Grinch on 17/12/2022.
//

import Foundation
import UIKit
import Domain
import ListingPictures
import PictureDetail

public protocol Coordinator {
    var navigationController : UINavigationController { get set }

    func start()
}

class MainCoordinator: Coordinator {

    typealias Dependencies = HasImageLoader & HasMediasRemoteStore & HasPicturesRepository
    // MARK: Coordinator properties
    var navigationController: UINavigationController

    // MARK: Private properties
    private let dependencies: Dependencies

    init(dependencies: Dependencies, navigationController: UINavigationController) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }

    // MARK: Coordinator method
    func start() {
        let rootVC = ListingPicturesViewController(dependencies: dependencies, flow: self)
        navigationController.pushViewController(rootVC, animated: true)
    }

}

extension MainCoordinator: ListingPicturesFlow {

    func showPictureDetail(id: String) {
        let pictureDetailVC = PictureDetailViewController(dependencies: dependencies, flow: self, pictureId: id)
        navigationController.pushViewController(pictureDetailVC, animated: true)
    }

}

extension MainCoordinator: PictureDetailFlow {

    func showHDImage(url: URL) {
        print(url)
    }

}
