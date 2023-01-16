//
//  MainDependencies.swift
//  ApodApp
//
//  Created by Grinch on 17/12/2022.
//

import Foundation
import Domain
import Repository
import RemoteStore

typealias MainDependencing = HasImageLoader & HasMediasRemoteStore & HasPicturesRepository

class MainDependencies: MainDependencing {

    let imageLoader: ImageLoading
    let mediasRemoteStore: MediasRemoteStoreProtocol

    lazy var picturesRepository: PicturesRepositoryProtocol = PicturesRepository(mediasRemoteStore: mediasRemoteStore)

    init() {
        imageLoader = ImageLoader.loader
        mediasRemoteStore = MediasRemoteStore(httpDataProvider: URLSession.shared)
    }

}
