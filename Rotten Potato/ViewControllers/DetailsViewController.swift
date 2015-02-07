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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var synopsis: UILabel!

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var containerView: UIView!
    
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
        
        self.scrollView.contentSize = CGSizeMake(320, 1000)
        var title = movie!["title"] as NSString
        NSLog("movie title: " + title)
        self.navigationItem.title = title
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
        
        let year = movie!["year"] as Int
        let name = movie!["title"] as String
        println("year: \(year), title: \(name)")
        self.movieTitle.text = "\(name) (\(year))"
        self.rating.text = movie!["mpaa_rating"] as NSString
        let ratings = movie!["ratings"] as NSDictionary
        let criticsScore = ratings["critics_score"] as NSInteger
        let audienceScore = ratings["audience_score"] as NSInteger
        
        self.score.text = "Critics Score: \(criticsScore), Audience Score: \(audienceScore)"
        self.synopsis.text = movie!["synopsis"] as NSString
        self.synopsis.sizeToFit()
        
        var containerRect = CGRectZero
        for view:UIView in self.containerView.subviews as [UIView] {
            containerRect = CGRectUnion(containerRect, view.frame)
        }
        var newFrame = self.containerView.frame
//        newFrame.size.width = containerRect.width
        newFrame.size.height = containerRect.height + 10
        self.containerView.frame = newFrame

        // readjust the scroll view size based on the size of the synopsis
        println(self.scrollView.contentSize)
        var contentRect = CGRectZero
        for view:UIView in self.scrollView.subviews as [UIView] {
            contentRect = CGRectUnion(contentRect, view.frame);
        }
        
        var backgroundFrame = self.background.frame
        backgroundFrame.size.height = contentRect.height
        self.background.frame = backgroundFrame

        self.scrollView.contentSize.height = contentRect.size.height

        println(self.scrollView.contentSize)
    }
}

