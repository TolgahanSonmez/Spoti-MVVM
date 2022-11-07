//
//  Artist.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 21.09.2022.
//

import Foundation
struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
}
