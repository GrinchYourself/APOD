//
//  Picture.swift
//  
//
//  Created by Grinch on 14/12/2022.
//

import Foundation

public protocol Picture {
    var id: String { get }
    var date: Date { get }
    var title: String { get }
    var explanation: String { get }
    var copyright: String? { get }
    var url: PicturesURL { get }
}

public protocol PicturesURL {
    var standard: URL? { get }
    var high: URL? { get }
}
