//
//  MediaDTO.swift
//  
//
//  Created by Grinch on 13/12/2022.
//

import Foundation
import Domain

struct MediaDTO: Decodable, Media {

    // MARK: Domain & Decodable properties
    let date: Date
    let explanation: String
    let title: String
    let url: String
    let hdUrl: String?
    let copyright: String?

    // MARK: Decodable Properties
    let mediaDTO: TypeDTO

    enum CodingKeys: String, CodingKey {
        case date
        case explanation
        case mediaDTO = "media_type"
        case title
        case url
        case hdUrl = "hdurl"
        case copyright
    }

    // MARK: Domain
    var media: Domain.MediaType {
        switch mediaDTO {
        case .video:
            return .video
        case .image:
            return .image
        }
    }
}

enum TypeDTO: String, Decodable {
    case video
    case image
}
