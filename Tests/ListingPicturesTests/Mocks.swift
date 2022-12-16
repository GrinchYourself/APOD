//
//  Mocks.swift
//  
//
//  Created by Grinch on 16/12/2022.
//

import Foundation
import Domain

struct Mocks {

    private static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter
    }()

    var pictures = [MockPicture(id: "GalaxyFlower_Strand_960",
                                date: dateFormatter.date(from: "17/10/2022")!,
                                title: "Milky Way Auroral Flower",
                                explanation: "Could the stem of our Milky Way bloom into an auroral flower?",
                                copyright: "Göran Strand",
                                url: MockPicturesURL(standard: URL(string: "https://apod.nasa.gov/apod/image/2210/GalaxyFlower_Strand_960.jpg"),
                                                     high: URL(string: "https://apod.nasa.gov/apod/image/2210/GalaxyFlower_Strand_1200.jpg"))),

                    MockPicture(id: "Ngc7497Cirrus_Trottier_960",
                                date: dateFormatter.date(from: "18/10/2022")!,
                                title: "A Galaxy Beyond Stars, Gas, Dust",
                                explanation: "Do we dare believe our eyes?  When we look at images of space,",
                                copyright: "Howard TrottierEmily Rice",
                                url: MockPicturesURL(standard: URL(string: "https://apod.nasa.gov/apod/image/2210/Ngc7497Cirrus_Trottier_960.jpg"),
                                                     high: URL(string: "https://apod.nasa.gov/apod/image/2210/Ngc7497Cirrus_Trottier_2976.jpg"))),
                    MockPicture(id: "stsci-pillarsofcreation1280c",
                                date: dateFormatter.date(from: "19/10/2022")!,
                                title: "Pillars of Creation",
                                explanation: "A now famous picture from the Hubble Space Telescope featured these star",
                                copyright: nil,
                                url: MockPicturesURL(standard: URL(string: "https://apod.nasa.gov/apod/image/2210/stsci-pillarsofcreation1280c.jpg"),
                                                     high: URL(string: "https://apod.nasa.gov/apod/image/2210/stsci-pillarsofcreation.png"))),
                    MockPicture(id: "andromeda-over-alps1100",
                                date: dateFormatter.date(from: "20/10/2022")!,
                                title: "Andromeda in Southern Skies",
                                explanation: "Looking north from southern New Zealand, the Andromeda Galaxy never gets more than about five degrees above the horizon.",
                                copyright: "Ian Griffin",
                                url: MockPicturesURL(standard: URL(string: "https://apod.nasa.gov/apod/image/2210/andromeda-over-alps1100.jpg"),
                                                     high: URL(string: "https://apod.nasa.gov/apod/image/2210/andromeda-over-alps.jpg"))),
                    MockPicture(id: "20221011NGC1499CaliforniaNebula1024",
                                date: dateFormatter.date(from: "21/10/2022")!,
                                title: "NGC 1499: The California Nebula",
                                explanation: "Drifting through the Orion Arm of the spiral Milky Way Galaxy,",
                                copyright: "this cosmic cloud",
                                url: MockPicturesURL(standard: URL(string: "https://apod.nasa.gov/apod/image/2210/20221011NGC1499CaliforniaNebula1024.jpg"),
                                                     high: URL(string: "https://apod.nasa.gov/apod/image/2210/20221011NGC1499CaliforniaNebula4096.jpg")))
    ]
}

struct MockPicture: Picture {
    let id: String
    let date: Date
    let title: String
    let explanation: String
    let copyright: String?
    let url: Domain.PicturesURL
}

struct MockPicturesURL: PicturesURL {
    let standard: URL?
    let high: URL?
}
