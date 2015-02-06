//
//  TableViewController.swift
//  Rotten Potato
//
//  Created by Ding, Quan on 2/4/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var boxofficeMovies: [Movie] = []
    var movies:NSArray?
    
    @IBOutlet weak var movieTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.navigationController?.navigationBarHidden = false
        var movie = Movie(id:"123", title: "Harry Potter and the Deathly Hallows - Part 2", thumbnailImageUrl:"http://content8.flixster.com/movie/11/15/86/11158674_tmb.jpg", runtime:130, year:2011 )
        movie.synopsis = "Harry Potter and the Deathly Hallows - Part 2, is the final adventure in the Harry Potter film series. The much-anticipated motion picture event is the second of two full-length parts. In the epic finale, the battle between the good and evil forces of the wizarding world escalates into an all-out war. The stakes have never been higher and no one is safe. But it is Harry Potter who may be called upon to make the ultimate sacrifice as he draws closer to the climactic showdown with Lord Voldemort. It all ends here. -- (C) Warner Bros  Harry Potter and the Deathly Hallows - Part 2, is the final adventure in the Harry Potter film series. The much-anticipated motion picture event is the second of two full-length parts. In the epic finale, the battle between the good and evil forces of the wizarding world escalates into an all-out war. The stakes have never been higher and no one is safe. But it is Harry Potter who may be called upon to make the ultimate sacrifice as he draws closer to the climactic showdown with Lord Voldemort. It all ends here. -- (C) Warner Bros  Harry Potter and the Deathly Hallows - Part 2, is the final adventure in the Harry Potter film series. The much-anticipated motion picture event is the second of two full-length parts. In the epic finale, the battle between the good and evil forces of the wizarding world escalates into an all-out war. The stakes have never been higher and no one is safe. But it is Harry Potter who may be called upon to make the ultimate sacrifice as he draws closer to the climactic showdown with Lord Voldemort. It all ends here. -- (C) Warner Bros"
        movie.highresImageUrl = "http://content8.flixster.com/movie/11/15/86/11158674_ori.jpg"
//        var movies:[Movie] = RottenTomatoService.getBoxOfficeMovies()
//        boxofficeMovies.append(movie)
        let apiBase = "http://api.rottentomatoes.com/api/public/v1.0/"
        let apiKey = "cdctmek4jpff5qbg5xazrfdf"
        let boxofficeMoviesURL = apiBase + "lists/movies/box_office.json?apikey=\(apiKey)"
        println("request url: \(boxofficeMoviesURL)")
        
        var url = NSURL(string: boxofficeMoviesURL)!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            
//            println("response: \(responseDictionary)")
            self.movies = responseDictionary["movies"] as? NSArray
            println(self.movies)
            self.movieTable.reloadData();
        }
        
//        let apiBase = "http://api.rottentomatoes.com/api/public/v1.0/"
//        let apiKey = "cdctmek4jpff5qbg5xazrfdf"
//        let boxofficeMoviesURL = apiBase + "lists/movies/box_office.json?apikey=\(apiKey)"
//        println("request url: \(boxofficeMoviesURL)")
//        let url = NSURL(string: boxofficeMoviesURL)!
//        var request = NSURLRequest(URL: url)
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
//
////        let request = NSMutableURLRequest(URL: NSURL(string: boxofficeMoviesURL)!)
////        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
//            var errorValue: NSError? = nil
//            let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
//            
////            println(dictionary["movies"])
//            self.movies = dictionary["movies"] as? NSArray
//            println(self.movies)
//            self.movieTable.reloadData();
//        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        
//        self.navigationController?.navigationBarHidden = true
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.movies?.count{
            return count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as MovieTableViewCell
        
//        let movie = boxofficeMovies[indexPath.row]
//        cell.movieTitle.text = movie.title
//        cell.synopsis.text = movie.synopsis
//        cell.synopsis.sizeToFit()
//        let imageUrl = NSURL(string: movie.thumbnailImageUrl)
//        cell.posterImage.setImageWithURL(imageUrl)
        let movie = self.movies![indexPath.row] as NSDictionary
        cell.movieTitle.text = movie["title"] as NSString
        cell.synopsis.text = movie["synopsis"] as NSString
        cell.synopsis.sizeToFit()
        let imageUrls = movie["posters"] as NSDictionary
        let thumbUrl = imageUrls["thumbnail"] as NSString
        cell.posterImage.setImageWithURL(NSURL(string: thumbUrl))
        
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let movie = boxofficeMovies[indexPath.row] as Movie
//        if let detailsViewController = segue.destinationViewController as? DetailsViewController{
//            let row = self.tableView!.indexPathForSelectedRow()!.row
//            let movie = boxofficeMovies[row] as Movie
//            detailsViewController.movie = movie
//        }
//        self.performSegueWithIdentifier("showDetails", sender: indexPath)
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetails"{
            if let detailsViewController = segue.destinationViewController as? DetailsViewController{
                let row = self.movieTable!.indexPathForSelectedRow()!.row
                let movie = self.movies![row] as NSDictionary
                detailsViewController.movie = movie
            }
        }
    }
}
