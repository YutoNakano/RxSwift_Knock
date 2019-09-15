//
//  TopViewModel.swift
//  conpass_client
//
//  Created by 中野湧仁 on 2019/09/13.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TopEntryViewModel {
    private let topEntryViewModel: TopEntryModelProtocol
    private let disposeBag = DisposeBag()
    
    var entries: [Entry.Value] {
        return _entries.value
    }
    
    private let _entries = BehaviorRelay<[Entry.Value]>(value: [])
    
    let reloadData: Observable<Void>
    
    init(searchBarText: Observable<String?>,
         searchButtonClicked: Observable<Void>,
         model: TopEntryModelProtocol) {
        self.topEntryViewModel = model
        
        self.reloadData = _entries.map { _ in }

        
        let searchResponse = searchButtonClicked
            .withLatestFrom(searchBarText)
            .flatMapFirst {[weak self] text ->
                Observable<Event<[Entry.Value]>> in
                guard let me = self, let query = text else {
                    return .empty()
                }
                return me.topEntryViewModel
                    .fetchEntry(query: query)
                    // Observable<T>をObservable<Event<T>>に変換
                    .materialize()
        }
        
        // Observable<Event<[Entry]>>型
        searchResponse
            .flatMap { event -> Observable<[Entry.Value]> in
                
                event.element.map(Observable.just) ?? .empty()
            }
            .bind(to: _entries)
            .disposed(by: disposeBag)
        
        searchResponse
            .flatMap { event -> Observable<Error> in
                event.error.map(Observable.just) ?? .empty()
        }
            .subscribe(onNext: { error in
                // TODO: エラー処理
            })
        .disposed(by: disposeBag)
    }
}
