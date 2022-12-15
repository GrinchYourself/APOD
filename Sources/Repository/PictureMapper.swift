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
        self.id = Self.makeIdentifier(from: media.url)
        self.date = media.date
        self.title = media.title
        self.explanation = media.explanation
        self.copyright = media.copyright
        self.url = URLMapper(standard: URL(string: media.url),
                             high: URL(string: media.hdUrl ?? ""))
    }

    private static func makeIdentifier(from url: String) -> String {
        guard let name = url.split(separator: "/", omittingEmptySubsequences: true).last else { return "" }
        guard let identifier = name.split(separator: ".").first else { return "" }
        return String(identifier)
    }

}

struct URLMapper: Domain.PicturesURL {
    let standard: URL?
    let high: URL?
}
