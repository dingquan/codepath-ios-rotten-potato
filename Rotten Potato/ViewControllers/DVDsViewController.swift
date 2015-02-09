//
//  DVDsViewController.swift
//  Rotten Potato
//
//  Created by Ding, Quan on 2/7/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit

class DVDsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var dvds:NSArray?
    var refreshControl: UIRefreshControl!
    
    let apiBase = "http://api.rottentomatoes.com/api/public/v1.0/"
    let apiKey = "cdctmek4jpff5qbg5xazrfdf"
    
    @IBOutlet weak var dvdTable: UITableView!
    @IBOutlet weak var errorBar: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        dvdTable.insertSubview(refreshControl, atIndex: 0)
        
        fetchDvds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.dvds?.count{
            return count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DVDCell", forIndexPath: indexPath) as MovieTableViewCell
        
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
        
        let movie = self.dvds![indexPath.row] as NSDictionary
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
//        cell.posterImage.setImageWithURL(NSURL(string: thumbUrl))
        var urlReq = NSURLRequest(URL: NSURL(string: thumbUrl)!)
        
        cell.posterImage.setImageWithURLRequest(urlReq, placeholderImage: nil,
            success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image:UIImage!) -> Void in
                cell.posterImage.alpha = 0.0
                cell.posterImage.image = image
                UIView.animateWithDuration(0.25, animations: {cell.posterImage.alpha = 1.0 })
            }, failure: { (request:NSURLRequest!, response:NSHTTPURLResponse!, error:NSError!) -> Void in
                println(error)
        })
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDvdDetails"{
            if let detailsViewController = segue.destinationViewController as? DetailsViewController{
                let row = self.dvdTable!.indexPathForSelectedRow()!.row
                let movie = self.dvds![row] as NSDictionary
                detailsViewController.movie = movie
            }
        }
    }
    
    func onRefresh(){
        fetchDvds()
        self.refreshControl.endRefreshing()
    }
    
    func fetchDvds(){
        let dvdsURL = apiBase + "lists/dvds/top_rentals.json?apikey=\(apiKey)"
        println("request url: \(dvdsURL)")
        
        var url = NSURL(string: dvdsURL)!
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
                
                self.dvds = responseDictionary["movies"] as? NSArray
                println(self.dvds)
                self.dvdTable.reloadData();
                self.errorBar.hidden = true
            }
            self.activityIndicator.stopAnimating()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
