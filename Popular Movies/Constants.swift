//
//  Constants.swift
//  Popular Movies
//
//  Created by Owen LaRosa on 6/24/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation

public struct Constants {
    
    public struct PosterConstants {
        static let posterBasePath = "http://image.tmdb.org/t/p/"
        static let imageSize = "w185"
    }
    
    public struct Keys {
        static let id = "id"
        static let title = "title"
        static let posterPath = "poster_path"
        static let releaseDate = "release_date"
        static let rating = "vote_average"
        static let overview = "overview"
    }
    
}
