//
//  PictureThumbnail.swift
//  
//
//  Created by Grinch on 16/12/2022.
//

import Foundation
import Domain

struct PictureThumbnail: Hashable {

    let id: String
    let date: String
    let url: URL?

    init(_ picture: Picture, dateFormatter: DateFormatter) {
        id = picture.id
        date = dateFormatter.string(from: picture.date)
        url = picture.url.standard
    }

}
