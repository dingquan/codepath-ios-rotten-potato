//
//  ViewController.swift
//  Rotten Potato
//
//  Created by Ding, Quan on 2/3/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
//    var movie:Movie?
    var movie:NSDictionary?

    @IBOutlet weak var posterImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadMovieDetails()
    }
    
    func reloadMovieDetails() {
        if (movie == nil){
            return
        }
        let imageUrls = movie!["posters"] as NSDictionary
        var detailedUrl = imageUrls["detailed"] as NSString
        detailedUrl = detailedUrl.stringByReplacingOccurrencesOfString("_tmb", withString: "_ori")
        let imageUrl = NSURL(string: detailedUrl)
        self.posterImage.setImageWithURL(imageUrl)
//        self.score.text = "blahblah"
//        self.movieTitle.text = movie?.title
//        self.synopsis.text = movie?.synopsis
    }
}

