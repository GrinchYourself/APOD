//
//  PictureDTO.swift
//  
//
//  Created by Grinch on 13/12/2022.
//

import Foundation

public struct MediaDTO: Decodable {
    let date: Date
    let explanation: String
    let media: TypeDTO
    let title: String
    let url: String
    let hdUrl: String?
    let copyright: String?

    enum CodingKeys: String, CodingKey {
        case date
        case explanation
        case media = "media_type"
        case title
        case url
        case hdUrl = "hdurl"
        case copyright
    }

}

enum TypeDTO: String, Decodable {
    case video
    case image
}
