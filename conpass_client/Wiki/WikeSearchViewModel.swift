//
//  WikeSearchViewModel.swift
//  qiita_client
//
//  Created by 中野湧仁 on 2019/09/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import RxSwift

final class WikiSearchViewModel {
    
    let wikipediaPages: Observable<[WikipediaPage]>
    let error: Observable<Error>
    
    private let disposeBag = DisposeBag()
    
    init(searchWord: Observable<String>, model: WikiApiClientProtocol) {
        
        let results = searchWord
            .filter { 3 <= $0.count }
            // イベントを Observable に変換し、常に１つの Observable のイベントしか通知しない
            .flatMapLatest {
                return model.search(from: $0)
                    .materialize()
        }
        .share(replay: 1)
        
        wikipediaPages = results
            .flatMap { $0.element.map(Observable.just) ?? .empty() }
        
        
        error = results
            .flatMap { $0.error.map(Observable.just) ?? .empty() }
    }
}
