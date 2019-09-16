//
//  WikiAPIClient.swift
//  qiita_client
//
//  Created by 中野湧仁 on 2019/09/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol WikiApiClientProtocol {
    func search(from word: String) -> Observable<[WikipediaPage]>
}

class WikiApiClient : WikiApiClientProtocol {
    
    private let host = URL(string: "https://ja.wikipedia.org")!
    // 1.
    private let URLSession: Foundation.URLSession
    
    init(URLSession: Foundation.URLSession) {
        // URLSessionも外からカスタマイズできるようにしておく
        self.URLSession = URLSession
    }
    
    func search(from word: String) -> Observable<[WikipediaPage]> {
        // 2.
        var components = URLComponents(url: host, resolvingAgainstBaseURL: false)!
        components.path = "/w/api.php"
        
        let items = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "list", value: "search"),
            URLQueryItem(name: "srsearch", value: word)
        ]
        
        components.queryItems = items
        let request = URLRequest(url: components.url!)
        // 3.
        return URLSession.rx.response(request: request)
            .map { pair in
                do {
                    let response = try JSONDecoder().decode(WikipediaSearchResponse.self,
                                                            from: pair.data)
                    
                    return response.query.search
                } catch {
                    // 4.
                    throw error
                }
        }
    }
}
