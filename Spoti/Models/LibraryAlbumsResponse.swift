//
//  LibraryAlbumsResponse.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 17.02.2023.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
