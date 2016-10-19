//
//  TrailerModel.swift
//  Popular Movies
//
//  Created by Owen LaRosa on 10/19/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation

open class TrailerModel {
    
    open let identifier: String
    open let key: String
    open let name: String
    
    public init(properties: [String: AnyObject]) {
        identifier = properties[Constants.TrailerKeys.id] as? String ?? ""
        key = properties[Constants.TrailerKeys.key] as? String ?? ""
        name = properties[Constants.TrailerKeys.name] as? String ?? ""
    }
    
}