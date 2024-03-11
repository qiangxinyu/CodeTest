//
//  ITunesModel.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/6.
//

import Foundation
import ObjectMapper

struct iTunesModel: Mappable {
    var resultCount: Int = 0
    var results: [SongModel] = []
    
    
    init(){}
    init?(map: ObjectMapper.Map) {}
    
    mutating func mapping(map: ObjectMapper.Map) {
        resultCount <- map["resultCount"]
        results <- map["results"]
    }
}

struct SongModel: Mappable {
    var artistName = ""
    var trackName = ""
    var artworkUrl = ""
    var trackPrice: Float = 0
    
    var artistLetter = ""
    
    init(){}
    init?(map: ObjectMapper.Map) {}
    
    mutating func mapping(map: ObjectMapper.Map) {
        artistName <- map["artistName"]
        trackName <- map["trackName"]
        artworkUrl <- map["artworkUrl100"]
        trackPrice <- map["trackPrice"]
        
        artistLetter = artistName.toLetter().uppercased()
        
    }
}
