//
//  TrailerCollectionViewCell.swift
//  Popular Movies
//
//  Created by Owen LaRosa on 10/20/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit

class TrailerCollectionViewCell: UICollectionViewCell {
    
    var videoUrl = ""
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if let url = URL(string: videoUrl) {
            UIApplication.shared.openURL(url)
        }
    }
    
    var dataTask: URLSessionTask? {
        didSet {
            if let task = oldValue {
                task.cancel()
            }
        }
    }
    
}
