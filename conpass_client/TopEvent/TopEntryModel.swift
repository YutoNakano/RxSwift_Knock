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
    func fetchEntry(query: String) -> Observable<[Entry.Value]>
}

final class TopEntryModel: TopEntryModelProtocol {
    let endPoint = "https://api.cognitive.microsoft.com/bing/v7.0/news/search"
    
    let headers = [
        "Ocp-Apim-Subscription-Key": Config.apiKey
    ]
    
    var params: [String: AnyObject] = [
        "count": "20" as AnyObject,
        "mkt": "ja-JP" as AnyObject,
        "safesearch": "Moderate" as AnyObject
    ]
    
    func request(query: String, completion: @escaping ((Swift.Result<[Entry.Value], Error>) -> Void)) {
        params["q"] = query as AnyObject
    
        Alamofire.request(endPoint, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case let .success(value):
                let result = try! JSONDecoder().decode(Entry.self, withJSONObject: value, options: .prettyPrinted)
                completion(.success(result.value))
            case let .failure(error):
                completion(.failure(error))
            }
        }
        
    }
    
    func fetchEntry(query: String) -> Observable<[Entry.Value]> {
        
        return Observable.create { [weak self] observer in
            let _ = self?.request(query: query) { result in
                switch result {
                case let .success(response):
                    observer.onNext(response)
                case let .failure(error):
                    observer.onError(error)
                }
            }
         return Disposables.create()
        }
    }
    
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, withJSONObject object: Any, options opt: JSONSerialization.WritingOptions = []) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: object, options: opt)
        return try decode(T.self, from: data)
    }
}
