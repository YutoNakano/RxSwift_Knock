//
//  WikipediaSearchResponse.swift
//  qiita_client
//
//  Created by 中野湧仁 on 2019/09/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation

struct WikipediaSearchResponse: Decodable {
    
    let query: Query
    
    struct Query: Decodable {
        let search: [WikipediaPage]
    }
    
}

struct WikipediaPage: Decodable {
    let title: String
    let pageid: Int
    
    var url: URL {
        return URL(string: "https://ja.wikipedia.org/w/index.php?curid=\(pageid)")!
    }
}
