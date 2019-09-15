//
//  QiitaEntry.swift
//  qiita_client
//
//  Created by 中野湧仁 on 2019/09/15.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation

struct QiitaEntry: Codable {
    let body: Body
    
    struct Body: Codable {
        let title: [String]
    }
}
