//
//  MoviesController.swift
//  Popular Movies
//
//  Created by Owen LaRosa on 6/24/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit

class MoviesController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var movies: [Movie]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MoviesController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("movieCollectionViewCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        
        let movie = movies[indexPath.row]
        
        // set movie title
        cell.label.text = movie.title
        
        // check cache for the image
        if let image = ImageCache().imageWithIdentifier(movie.posterPath) {
            cell.imageView.image = image
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                // perform network request on background queue
                cell.dataTask = TMDBClient.sharedInstance().downloadImageAtLocation(movie.getFullPosterPath()) {data, error in
                    if data != nil {
                        guard let image = UIImage(data: data!) else {
                            return
                        }
                        // add image to the cache
                        ImageCache().storeImage(image, withIdentifier: movie.posterPath)
                        dispatch_async(dispatch_get_main_queue()) {
                            // update UI on main queue
                            cell.imageView.image = image
                        }
                    }
                }
            }
        }
        return cell
    }
    
}
