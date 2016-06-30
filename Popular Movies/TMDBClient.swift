//
//  TMDBClient.swift
//  Popular Movies
//
//  Created by Owen LaRosa on 6/28/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation

public enum TMDBErrors: ErrorType {
    case ParsingError
    case MovieSearchError
    case ImageDownloadError
    case InvalidUrlError
}

public class TMDBClient {
    
    private struct RequestKeys {
        static let baseUrl = "https://api.themoviedb.org/3/"
        static let apiKey = ""
    }
    
    private struct JSONKeys {
        static let id = "id"
        static let title = "title"
        static let posterPath = "poster_path"
        static let releaseDate = "release_date"
        static let rating = "vote_average"
        static let overview = "overview"
    }
    
    /// Build TMDB search url from method and parameters
    private func buildUrl(method method: String, parameters: String) -> String {
        return "\(RequestKeys.baseUrl)\(method)?api_key=\(RequestKeys.apiKey)\(parameters)"
    }
    
    /// Convert JSON data into Movie array
    private func getMoviesFromJSON(jsonData: NSData) throws -> [Movie] {
        var movies = [Movie]()
        do {
            if let jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) as? [String: AnyObject], jsonArray = jsonObject["results"] as? [[String: AnyObject]] {
                for i in jsonArray {
                    var properties = [String: AnyObject]()
                    properties[JSONKeys.id] = i[JSONKeys.id]
                    properties[JSONKeys.title] = i[JSONKeys.title]
                    properties[JSONKeys.posterPath] = i[JSONKeys.posterPath]
                    properties[JSONKeys.releaseDate] = i[JSONKeys.releaseDate]
                    properties[JSONKeys.rating] = i[JSONKeys.rating]
                    properties[JSONKeys.overview] = i[JSONKeys.overview]
                    let movie = Movie(properties: properties)
                    movies.append(movie)
                }
            }
        } catch {
            throw TMDBErrors.ParsingError
        }
        return movies
    }
    
    /// Return data task for movie search
    public func searchMoviesWithMethod(method: String, parameters: String, completionHandler: (movies: [Movie]?, error: ErrorType?) -> Void) -> NSURLSessionTask! {
        let session = NSURLSession.sharedSession()
        guard let url = NSURL(string: buildUrl(method: method, parameters: parameters)) else {
            completionHandler(movies: nil, error: TMDBErrors.InvalidUrlError)
            return nil
        }
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(movies: nil, error: TMDBErrors.MovieSearchError)
            } else {
                do {
                    let movies = try self.getMoviesFromJSON(data!)
                    completionHandler(movies: movies, error: nil)
                } catch {
                    completionHandler(movies: nil, error: error)
                }
            }
        }
        task.resume()
        
        return task
    }
    
    /// Return data task for poster image download
    public func downloadImageAtLocation(location: String, completionHandler: (imageData: NSData?, error: ErrorType?) -> Void) -> NSURLSessionTask! {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        guard let url = NSURL(string: location) else {
            completionHandler(imageData: nil, error: TMDBErrors.InvalidUrlError)
            return nil
        }
        let request = NSMutableURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                completionHandler(imageData: nil, error: TMDBErrors.ImageDownloadError)
            } else {
                completionHandler(imageData: data, error: nil)
            }
        }
        task.resume()
        
        return task
    }
    
    class func sharedInstance() -> TMDBClient {
        
        struct Singleton {
            static var sharedInstance = TMDBClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
