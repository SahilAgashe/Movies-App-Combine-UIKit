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
    
    private enum CodingKeyss: String, CodingKey {
        case title = "Title"
        case year = "Year"
    }
}
