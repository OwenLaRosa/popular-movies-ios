//
//  MovieModel.swift
//  Popular Movies
//
//  Created by Owen LaRosa on 6/24/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation

public class MovieManager {
    
    public static let sharedInstance = MovieManager()
    public var movies = [Movie]()
    
}

public class Movie {
    
    public let id: Int
    public let title: String
    public let posterPath: String
    public let releaseDate: String
    public let rating: Double
    public let overview: String
    
    public init(properties: [String: AnyObject]) {
        id = properties[Constants.Keys.id] as! Int
        title = properties[Constants.Keys.title] as! String
        posterPath = properties[Constants.Keys.posterPath] as! String
        releaseDate = properties[Constants.Keys.releaseDate] as! String
        rating = properties[Constants.Keys.rating] as! Double
        overview = properties[Constants.Keys.overview] as! String
    }
    
    public func getFullPosterPath() -> String {
        return "\(Constants.PosterConstants.posterBasePath)\(Constants.PosterConstants.imageSize)/\(posterPath)"
    }
    
}


