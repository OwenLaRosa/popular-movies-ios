//
//  MovieModel.swift
//  Popular Movies
//
//  Created by Owen LaRosa on 6/24/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation

open class MovieManager {
    
    open static let sharedInstance = MovieManager()
    open var movies = [Movie]()
    
}

open class Movie {
    
    open let id: Int
    open let title: String
    open let posterPath: String
    open let releaseDate: String
    open let rating: Double
    open let overview: String
    
    public init(properties: [String: AnyObject]) {
        id = properties[Constants.MovieKeys.id] as! Int
        title = properties[Constants.MovieKeys.title] as! String
        posterPath = properties[Constants.MovieKeys.posterPath] as! String
        releaseDate = properties[Constants.MovieKeys.releaseDate] as! String
        rating = properties[Constants.MovieKeys.rating] as! Double
        overview = properties[Constants.MovieKeys.overview] as! String
    }
    
    open func getFullPosterPath() -> String {
        return "\(Constants.PosterConstants.posterBasePath)\(Constants.PosterConstants.imageSize)/\(posterPath)"
    }
    
}


