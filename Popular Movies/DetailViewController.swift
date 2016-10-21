//
//  DetailViewController.swift
//  Popular Movies
//
//  Created by Owen LaRosa on 8/13/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // name of the movie
    @IBOutlet weak var titleLabel: UILabel!
    
    // poster image
    @IBOutlet weak var posterImageView: UIImageView!
    
    // release year to 4 characters
    @IBOutlet weak var yearLabel: UILabel!
    
    // colored star, followed by rating out of 10
    @IBOutlet weak var ratingTextView: UILabel!
    
    // toggles favorite state of a movie
    @IBOutlet weak var favoriteButton: UIButton!
    
    // brief overview of the movie
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var trailerCollectionView: UICollectionView!
    
    var movie: Movie!
    var trailers = [Trailer]()
    var trailerDownloadTask: URLSessionTask?
    var reviews = [Review]()
    var reviewDownloadTask: URLSessionTask?
    var client = TMDBClient()
    
    //
    private var downloadTask: URLSessionTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie.title
        // TODO: show movie poster
        // only show the year, 4 characters
        let yearIndex = movie.releaseDate.index(movie.releaseDate.startIndex, offsetBy: 4)
        yearLabel.text = movie.releaseDate.substring(to: yearIndex)
        ratingTextView.text = "⋆ \(movie.rating)/10"
        descriptionLabel.text = movie.overview
        
        downloadPoster()
        
        // fetch trailers and reviews asynchronously
        downloadTrailers()
        downloadReviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.frame.origin.y = -(navigationController?.navigationBar.frame.size.height)!
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if downloadTask != nil {
            downloadTask.cancel()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // prevent horizontal scrolling
        scrollView.contentSize.width = UIScreen.main.bounds.width
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    }
    
    func downloadPoster() {
        if let image = ImageCache().imageWithIdentifier(movie.posterPath) {
            posterImageView.image = image
        } else {
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                self.downloadTask = TMDBClient.sharedInstance().downloadImageAtLocation(self.movie.getFullPosterPath()) {data, error in
                    if data != nil {
                        guard let image = UIImage(data: data!) else {
                            return
                        }
                        ImageCache().storeImage(image, withIdentifier: self.movie.getFullPosterPath())
                        DispatchQueue.main.async {
                            self.posterImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    func downloadTrailers() {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            self.trailerDownloadTask = self.client.getTrailersForMovieId(id: self.movie.id) {trailers, error in
                DispatchQueue.main.async {
                    if trailers != nil {
                        self.trailers = trailers!
                        self.trailerCollectionView.reloadData()
                    } else {
                        // show trailer download error
                    }
                }
            }
        }
    }
    
    func downloadReviews() {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            self.reviewDownloadTask = self.client.getReviewsForMovieId(id: self.movie.id) {reviews, error in
                if reviews != nil {
                    self.reviews = reviews!
                } else {
                    // show review download error
                }
            }
        }
    }
    
}

extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trailers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrailerCollectionViewCell", for: indexPath) as! TrailerCollectionViewCell
        
        let trailer = trailers[indexPath.row]
        
        // set video link for when play button is pressed
        cell.videoUrl = trailer.videoUrl
        
        if let image = ImageCache().imageWithIdentifier(trailer.thumbnailUrl) {
            cell.thumbnail.image = image
        } else {
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                // perform network request on background queue
                cell.dataTask = TMDBClient.sharedInstance().downloadImageAtLocation(trailer.thumbnailUrl) {data, error in
                    if data != nil {
                        guard let image = UIImage(data: data!) else {
                            return
                        }
                        // add image to the cache
                        ImageCache().storeImage(image, withIdentifier: trailer.thumbnailUrl)
                        DispatchQueue.main.async {
                            // update UI on main queue
                            cell.thumbnail.image = image
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
}
