//
//  TopEntryModel.swift
//  conpass_client
//
//  Created by 中野湧仁 on 2019/09/13.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire


protocol TopEntryModelProtocol {
    func request()
}

final class TopEntryModel: TopEntryModelProtocol {
    let endPoint = "https://api.cognitive.microsoft.com/bing/v7.0/news/search"
    
    let headers = [
        "Ocp-Apim-Subscription-Key": Config.apiKey
    ]
    
    var dic = [String:AnyObject]()
    
    
    
    func request() {
        dic["q"] = "介護" as AnyObject?
        dic["count"] = "20" as AnyObject?
        dic["mkt"] = "ja-JP" as AnyObject?
        dic["safesearch"] = "Moderate" as AnyObject?
        
        Alamofire.request(endPoint, method: .get, parameters: dic, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case let .success(value):
                print(value)
                let result = try! JSONDecoder().decode(Entry.self, withJSONObject: value, options: .prettyPrinted)
                print(result)
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, withJSONObject object: Any, options opt: JSONSerialization.WritingOptions = []) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: object, options: opt)
        return try decode(T.self, from: data)
    }
}
