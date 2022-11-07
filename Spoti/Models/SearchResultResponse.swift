//
//  SearchResultResponse.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 21.09.2022.
//
import Foundation


//composit bir obje döner
//arama yaptığımızda dönen sonuçlara karşılık bu struct yapısı karşılayacak

struct SearchResultsResponse : Codable {
    let albums : SearchAlbumResponse
    let artists : SearchArtistsResponse
    let playlists : SearchPlayListResponse
    let tracks : SearchTrackssResponse
    
}


struct SearchAlbumResponse : Codable {
    let items : [Album]
}

struct SearchArtistsResponse : Codable {
    let items : [Artist]
}

struct SearchPlayListResponse : Codable {
    let items : [Playlist]
}

struct SearchTrackssResponse : Codable {
    let items : [AudioTrack]
}

