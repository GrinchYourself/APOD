//
//  Media.swift
//  
//
//  Created by Grinch on 14/12/2022.
//

import Foundation

public protocol Media {
    var date: Date { get }
    var explanation: String { get }
    var media: MediaType { get }
    var title: String { get }
    var url: String { get }
    var hdUrl: String? { get }
    var copyright: String? { get }
}

public enum MediaType {
    case video
    case image
}
