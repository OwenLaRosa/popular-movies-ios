//
//  ReviewModel.swift
//  Popular Movies
//
//  Created by Owen LaRosa on 10/19/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation

open class Review {
    
    open let author: String
    open let content: String
    
    public init (properties: [String: AnyObject]) {
        author = properties[Constants.ReviewKeys.author] as? String ?? ""
        content = properties[Constants.ReviewKeys.content] as? String ?? ""
    }
    
}
