//
//  Movie.swift
//  Movies App
//
//  Created by SAHIL AMRUT AGASHE on 05/06/24.
//

import Foundation

struct MovieResponse: Decodable {
    let search: [Movie]
}

struct Movie: Decodable {
    let title: String
    let year: String
    let imdbId: String
    let type: String
    let poster: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbId = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}
