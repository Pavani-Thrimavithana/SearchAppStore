//
//  itunes.swift
//  SearchApp
//
//  Created by Mac on 10/2/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation

struct itunes {
    let icon:String
    let name:String
    let company: String
    let type: String
    let genre: String
    let price: String
    
    enum SerializationError:Error{
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json:[String:Any]) throws {
        guard let name = json["artistName"] as? String else {throws SerializationError.missing("name missing")}
        guard let icon = json["artworkUrl160"] as? String else {throws SerializationError.missing("icon missing")}
        guard let company = json["sellerName"] as? String else {throws SerializationError.missing("company name missing")}
        guard let genre = json["primaryGenreName"] as? String else {throw SerializationError.missing("genre is missing")}
        guard let price = json["formattedPrice"] as? String else {throw SerializationError.missing("price is missing")}
        
        self.name = name
        self.icon = icon
        self.company = company
        self.genre = genre
        self.price = price
    }
    static basePath = "https://itunes.apple.com/search?term=Puzzle&limit=200&entity=software"
}
