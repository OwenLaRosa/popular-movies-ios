//
//  MovieCollectionViewCell.swift
//  Popular Movies
//
//  Created by Owen LaRosa on 6/30/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    /// Image view to display the movie poster
    @IBOutlet weak var imageView: UIImageView!
    /// Label to display the movie title
    @IBOutlet weak var label: UILabel!
    
    /// Current data task for image download
    var dataTask: URLSessionTask? {
        didSet {
            if let task = oldValue {
                task.cancel()
            }
        }
    }
    
}
