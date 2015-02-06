//
//  RottenTomatoService.swift
//  Rotten Potato
//
//  Created by Ding, Quan on 2/4/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import Foundation

struct RottenTomatoService{
    static let apiBase = "http://api.rottentomatoes.com/api/public/v1.0/"
    static let apiKey = "cdctmek4jpff5qbg5xazrfdf"
    
//    static func getBoxOfficeMovies() -> [NSDictionary]{
//        let movies:[Movie] = []
//        let boxofficeMoviesURL = apiBase + "lists/movies/box_office.json?apikey=\(apiKey)"
//        
//        let request = NSMutableURLRequest(URL: NSURL(string: boxofficeMoviesURL)!)
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
//            var errorValue: NSError? = nil
//            let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
//            
//            println(dictionary["movies"])
//            
//        })
//        
//        return movies
//    }
    
}