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
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie.title
        // TODO: show movie poster
        // only show the year, 4 characters
        let yearIndex = movie.releaseDate.index(movie.releaseDate.startIndex, offsetBy: 4)
        yearLabel.text = movie.releaseDate.substring(to: yearIndex)
        ratingTextView.text = "⋆ \(movie.rating)/10"
        descriptionLabel.text = movie.overview
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.frame.origin.y = -(navigationController?.navigationBar.frame.size.height)!
        
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
    
}
