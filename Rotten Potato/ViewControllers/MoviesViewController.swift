//
//  TableViewController.swift
//  Rotten Potato
//
//  Created by Ding, Quan on 2/4/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    var movies:NSArray?
    var searchResult:NSArray?
    var inSearch:Bool = false
    
    var refreshControl: UIRefreshControl!
    
    let apiBase = "http://api.rottentomatoes.com/api/public/v1.0/"
    let apiKey = "cdctmek4jpff5qbg5xazrfdf"
    
    @IBOutlet weak var movieTable: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var errorBar: UIView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        if (inSearch == true){
            if let count = self.searchResult?.count {
                return count
            }
            else {
                return 0
            }
        }
        else{
            if let count = self.movies?.count{
                return count
            } else {
                return 0
            }
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
        
        var movie:NSDictionary
        if !inSearch {
            movie = self.movies![indexPath.row] as NSDictionary
        }
        else {
            movie = self.searchResult![indexPath.row] as NSDictionary
        }
        
        cell.movieTitle.text = movie["title"] as NSString
        let synopsis = movie["synopsis"] as NSString
        let mpaaRating = movie["mpaa_rating"] as NSString
        
        // make mpaa-rating bold 
        var regularFont = UIFont.systemFontOfSize(12)
        var boldFont = UIFont.boldSystemFontOfSize(12)
        let attributes :Dictionary = [NSFontAttributeName: regularFont]
        let subAttributes :Dictionary = [NSFontAttributeName: boldFont]
        
        let ratingAndSynopsis = "\(mpaaRating) \(synopsis)"
        var attrString = NSMutableAttributedString(string: ratingAndSynopsis, attributes: attributes)
//        attrString.addAttribute(NSFontAttributeName, value: subAttributes, range: NSMakeRange(0, mpaaRating.length))
        
        cell.synopsis.attributedText = attrString
//        cell.synopsis.sizeToFit()
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
        
        if segue.identifier == "showMovieDetails"{
            if let detailsViewController = segue.destinationViewController as? DetailsViewController{
                let row = self.movieTable!.indexPathForSelectedRow()!.row
                var movie:NSDictionary
                if !inSearch {
                    movie = self.movies![row] as NSDictionary
                }
                else {
                    movie = self.searchResult![row] as NSDictionary
                }
                detailsViewController.movie = movie
            }
        }
    }
    
    func onRefresh(){
        inSearch = false
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
    
    func searchMovies(searchString: String){
        let encodedQuery = searchString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let searchMoviesURL = apiBase + "movies.json?apikey=\(apiKey)" + "&q=\(encodedQuery)"
        println("request url: \(searchMoviesURL)")
        
        var url = NSURL(string: searchMoviesURL)!
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
                
                self.searchResult = responseDictionary["movies"] as? NSArray
                println(self.searchResult)
                self.movieTable.reloadData();
                self.errorBar.hidden = true
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        var searchText:String = searchBar.text
        if searchText.isEmpty{
            return
        }
        inSearch = true
        NSLog("searching for " + searchBar.text)
        searchMovies(searchBar.text)
    }
    
}
