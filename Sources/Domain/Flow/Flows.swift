//
//  Flows.swift
//  
//
//  Created by Grinch on 17/12/2022.
//

import Foundation

public protocol ListingPicturesFlow: AnyObject {
    func showPictureDetail(id: String)
}

public protocol PictureDetailFlow: AnyObject {
    func showHDImage(url: URL)
}
