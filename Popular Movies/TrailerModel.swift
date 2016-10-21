//
//  TrailerModel.swift
//  Popular Movies
//
//  Created by Owen LaRosa on 10/19/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation

open class Trailer {
    
    open let identifier: String
    open let key: String
    open let name: String
    
    public init(properties: [String: AnyObject]) {
        identifier = properties[Constants.TrailerKeys.id] as? String ?? ""
        key = properties[Constants.TrailerKeys.key] as? String ?? ""
        name = properties[Constants.TrailerKeys.name] as? String ?? ""
    }
    
    var thumbnailUrl: String {
        return "https://img.youtube.com/vi/\(key)/0.jpg"
    }
    
    var videoUrl: String {
        return "https://www.youtube.com/watch?v=\(key)"
    }
    
}
