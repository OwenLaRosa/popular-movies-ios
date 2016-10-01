//
//  TMDBClient.swift
//  Popular Movies
//
//  Created by Owen LaRosa on 6/28/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation

public enum TMDBErrors: Error {
    case parsingError
    case movieSearchError
    case imageDownloadError
    case invalidUrlError
}

open class TMDBClient {
    
    fileprivate struct RequestKeys {
        static let baseUrl = "https://api.themoviedb.org/3/"
        static let apiKey = "f5bff038fbd62a3ccfedf06c2315d655"
    }
    
    fileprivate struct JSONKeys {
        static let id = "id"
        static let title = "title"
        static let posterPath = "poster_path"
        static let releaseDate = "release_date"
        static let rating = "vote_average"
        static let overview = "overview"
    }
    
    /// Build TMDB search url from method and parameters
    fileprivate func buildUrl(method: String, parameters: String) -> String {
        return "\(RequestKeys.baseUrl)\(method)?api_key=\(RequestKeys.apiKey)\(parameters)"
    }
    
    /// Convert JSON data into Movie array
    fileprivate func getMoviesFromJSON(_ jsonData: Data) throws -> [Movie] {
        var movies = [Movie]()
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: AnyObject], let jsonArray = jsonObject["results"] as? [[String: AnyObject]] {
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
            throw TMDBErrors.parsingError
        }
        return movies
    }
    
    /// Return data task for movie search
    open func searchMoviesWithMethod(_ method: String, parameters: String, completionHandler: @escaping (_ movies: [Movie]?, _ error: Error?) -> Void) -> URLSessionTask! {
        let session = URLSession.shared
        guard let url = URL(string: buildUrl(method: method, parameters: parameters)) else {
            completionHandler(nil, TMDBErrors.invalidUrlError)
            return nil
        }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if error != nil {
                completionHandler(nil, TMDBErrors.movieSearchError)
            } else {
                do {
                    let movies = try self.getMoviesFromJSON(data!)
                    completionHandler(movies, nil)
                } catch {
                    completionHandler(nil, error)
                }
            }
        }) 
        task.resume()
        
        return task
    }
    
    /// Return data task for poster image download
    open func downloadImageAtLocation(_ location: String, completionHandler: @escaping (_ imgeData: Data?, _ error: Error?) -> Void) -> URLSessionTask! {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        guard let url = URL(string: location) else {
            completionHandler(nil, TMDBErrors.invalidUrlError)
            return nil
        }
        
        let task = session.dataTask(with: url, completionHandler: {data, response, error in
            if error != nil {
                completionHandler(nil, TMDBErrors.imageDownloadError)
            } else {
                completionHandler(data, nil)
            }
        }) 
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
