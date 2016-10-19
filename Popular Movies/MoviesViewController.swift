//
//  MoviesViewController.swift
//  Popular Movies
//
//  Created by Owen LaRosa on 6/24/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set title color, only affects this view controller
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(colorLiteralRed: 0.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)]
        
        collectionView.delegate = self
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            TMDBClient.sharedInstance().searchMoviesWithMethod("movie/popular", parameters: "") {movies, error in
                if error != nil {
                    DispatchQueue.main.async {
                        self.showAlert()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.movies = movies!
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if view.frame.size.width > view.frame.size.height {
            // landscape mode, no status bar
            navigationController?.navigationBar.frame.origin.y = 0
        } else {
            // portrait mode, account for status bar height
            navigationController?.navigationBar.frame.origin.y = 20
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(navigationController?.navigationBar.frame.origin.y)
        print(navigationController?.navigationBar.frame.size.height)
        navigationController?.navigationBar.frame.origin.y = -(navigationController?.navigationBar.frame.size.height)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showDetail" {
            let destination = segue.destination as! DetailViewController
            destination.movie = sender as! Movie
        }
    }
    
}

extension MoviesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        let movie = movies[(indexPath as NSIndexPath).row]
        
        // set movie title
        cell.label.text = movie.title
        
        // check cache for the image
        if let image = ImageCache().imageWithIdentifier(movie.posterPath) {
            cell.imageView.image = image
        } else {
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                // perform network request on background queue
                cell.dataTask = TMDBClient.sharedInstance().downloadImageAtLocation(movie.getFullPosterPath()) {data, error in
                    if data != nil {
                        guard let image = UIImage(data: data!) else {
                            return
                        }
                        // add image to the cache
                        ImageCache().storeImage(image, withIdentifier: movie.posterPath)
                        DispatchQueue.main.async {
                            // update UI on main queue
                            cell.imageView.image = image
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Oops!", message: "There was an error using the network.", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
    
}

extension MoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[(indexPath as NSIndexPath).row]
        
        performSegue(withIdentifier: "showDetail", sender: movie)
    }
    
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width/2
        let height = width * 2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
