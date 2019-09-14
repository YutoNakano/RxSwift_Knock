//
//  Entry.swift
//  qiita_client
//
//  Created by 中野湧仁 on 2019/09/14.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation

struct Entry: Codable {
    let value: [Value]
    
    struct Value: Codable {
        let description: String
        let image: Thmbnail
        
        struct Thmbnail: Codable {
            let thumbnail: ImageDetails
            
            struct ImageDetails: Codable {
                let contentUrl: String
                let height: Int
                let width: Int
            }
        }
    }
}
