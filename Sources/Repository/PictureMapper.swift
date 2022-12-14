//
//  PictureMapper.swift
//  
//
//  Created by Grinch on 14/12/2022.
//

import Foundation
import Domain

struct PictureMapper: Picture {

    let id: String
    let date: Date
    let title: String
    let explanation: String
    let copyright: String?
    let url: Domain.PicturesURL

    init?(_ media: Media) {
        guard media.media  == .image else { return nil }
        self.id = ""
        self.date = media.date
        self.title = media.title
        self.explanation = media.explanation
        self.copyright = media.copyright
        self.url = URLMapper(standard: URL(string: media.url),
                             high: URL(string: media.hdUrl ?? ""))
    }
}

struct URLMapper: Domain.PicturesURL {
    let standard: URL?
    let high: URL?
}
