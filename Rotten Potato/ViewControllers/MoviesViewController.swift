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
    var refreshControl: UIRefreshControl!
    
    let apiBase = "http://api.rottentomatoes.com/api/public/v1.0/"
    let apiKey = "cdctmek4jpff5qbg5xazrfdf"
    
    @IBOutlet weak var movieTable: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var errorBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        var movies:[Movie] = RottenTomatoService.getBoxOfficeMovies()
//        boxofficeMovies.append(movie)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        movieTable.insertSubview(refreshControl, atIndex: 0)
        
        fetchMovies()
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
        
        // change the default margin of the table divider length
        if (cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:"))){
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if (cell.respondsToSelector(Selector("setSeparatorInset:"))){
            cell.separatorInset = UIEdgeInsetsMake(0, 4, 0, 0)
        }
        
        if (cell.respondsToSelector(Selector("setLayoutMargins:"))){
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
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
    
    func onRefresh(){
        fetchMovies()
        self.refreshControl.endRefreshing()
    }
    
    func fetchMovies(){
        let boxofficeMoviesURL = apiBase + "lists/movies/box_office.json?apikey=\(apiKey)"
        println("request url: \(boxofficeMoviesURL)")
        
        var url = NSURL(string: boxofficeMoviesURL)!
        var request = NSURLRequest(URL: url)
        
        self.activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            if let error = error as NSError?{
                println(error)
                self.errorBar.hidden = false
            }
            else if data != nil {
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                
                self.movies = responseDictionary["movies"] as? NSArray
                println(self.movies)
                self.movieTable.reloadData();
                self.errorBar.hidden = true
            }
            self.activityIndicator.stopAnimating()
        }
    }
}
