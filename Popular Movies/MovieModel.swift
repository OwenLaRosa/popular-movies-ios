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
    public let rating: Int
    public let overview: String
    
    public init(properties: [String: AnyObject]) {
        id = properties[""] as! Int
        title = properties[""] as! String
        posterPath = properties[""] as! String
        releaseDate = properties[""] as! String
        rating = properties[""] as! Int
        overview = properties[""] as! String
    }
    
    public func getFullPosterPath() -> String {
        return "\(Constants.PosterConstants.posterBasePath)\(Constants.PosterConstants.imageSize)/\(posterPath)"
    }
    
}


