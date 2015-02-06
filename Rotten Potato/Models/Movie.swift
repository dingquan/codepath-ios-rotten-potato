//
//  Movie.swift
//  Rotten Potato
//
//  Created by Ding, Quan on 2/4/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import Foundation

class Movie{
    var id:String
    var title:String
    var year:Int
    var runtime:Int
    var synopsis:String?
    var thumbnailImageUrl:String
    var highresImageUrl:String?
    var audienceScore:Int?
    var criticsScore:Int?
    
    init(id:String, title:String, thumbnailImageUrl:String, runtime:Int, year:Int){
        self.id = id
        self.title = title
        self.thumbnailImageUrl = thumbnailImageUrl
        self.runtime = runtime
        self.year = year
    }
}