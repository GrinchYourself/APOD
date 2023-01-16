//
//  Mocks.swift
//  
//
//  Created by Grinch on 14/12/2022.
//

import Domain
import Foundation

struct MockMedia: Domain.Media {
    let date: Date
    let explanation: String
    let media: Domain.MediaType
    let title: String
    let url: String
    let hdUrl: String?
    let copyright: String?
}

struct MockPicturesURL: Domain.PicturesURL {
    let standard: URL?
    let high: URL?
}

struct Mocks {
    private static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter
    }()

    var medias = [MockMedia(date: dateFormatter.date(from: "01/11/2022")!,
                            explanation: "Why is the Lobster Nebula forming some of the most massive stars known?",
                            media: .image,
                            title: "NGC 6357: The Lobster Nebula",
                            url: "https://apod.nasa.gov/apod/image/2211/Lobster_Blanco_960.jpg",
                            hdUrl: "https://apod.nasa.gov/apod/image/2211/Lobster_Blanco_4000.jpg",
                            copyright: nil),
                  MockMedia(date: dateFormatter.date(from: "03/11/2022")!,
                            explanation: "The small, northern constellation Triangulum harbors this magnificent face-on spiral galaxy",
                            media: .image,
                            title: "M33: The Triangulum Galaxy",
                            url: "https://apod.nasa.gov/apod/image/2211/M33-NOIR-HST-LL_1024.jpg",
                            hdUrl: "https://apod.nasa.gov/apod/image/2211/M33-NOIR-HST-LL.jpg",
                            copyright: "Robert Gendler"),
                  MockMedia(date: dateFormatter.date(from: "10/11/2022")!,
                            explanation: "How different does the universe look on very",
                            media: .video,
                            title: "Video: Powers of Ten",
                            url: "https://www.youtube.com/embed/0fKBhvDjuy0?rel=0",
                            hdUrl: nil,
                            copyright: "Charles & Ray EamesEames Office"),
                  MockMedia(date: dateFormatter.date(from: "15/11/2022")!,
                            explanation: "Watch for three things in this unusual eclipse video.",
                            media: .video,
                            title: "A Partial Eclipse of an Active Sun",
                            url: "https://www.youtube.com/embed/7dh5VL5YGoA?rel=0",
                            hdUrl: nil,
                            copyright: nil),
                  MockMedia(date: dateFormatter.date(from: "20/11/2022")!,
                            explanation: "Last May 16 the Moon slid through Earth's shadow,",
                            media: .image,
                            title: "Lunar Eclipse at the South Pole",
                            url: "https://apod.nasa.gov/apod/image/2211/Lunar-Eclipse-South-Pole_1024.jpg",
                            hdUrl: "https://apod.nasa.gov/apod/image/2211/Lunar-Eclipse-South-Pole.jpg",
                            copyright: "Aman Chokshi")
    ]
}
