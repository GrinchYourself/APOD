//
//  PictureMapperTests.swift
//  
//
//  Created by Grinch on 15/12/2022.
//

import XCTest
@testable import Repository

final class PictureMapperTests: XCTestCase {

    func testIdentifierForPictureMapper() {
        let media0 = Mocks().medias[0]
        let picture0 = PictureMapper(media0)
        XCTAssertNotNil(picture0)
        XCTAssertEqual("Lobster_Blanco_960", picture0?.id)

        let media1 = Mocks().medias[1]
        let picture1 = PictureMapper(media1)
        XCTAssertNotNil(picture1)
        XCTAssertEqual("M33-NOIR-HST-LL_1024", picture1?.id)

        let media2 = Mocks().medias[2]
        let picture2 = PictureMapper(media2)
        XCTAssertNil(picture2)

        let media3 = Mocks().medias[3]
        let picture3 = PictureMapper(media3)
        XCTAssertNil(picture3)

        let media4 = Mocks().medias[4]
        let picture4 = PictureMapper(media4)
        XCTAssertNotNil(picture4)
        XCTAssertEqual("Lunar-Eclipse-South-Pole_1024", picture4?.id)

    }
}
