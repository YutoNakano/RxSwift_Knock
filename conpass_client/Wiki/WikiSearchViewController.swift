//
//  WikiSearchViewController.swift
//  qiita_client
//
//  Created by 中野湧仁 on 2019/09/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SafariServices

final class WikiSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = WikiSearchViewModel(
            searchWord: searchBar.rx.text.orEmpty.asObservable(),
            model: WikiApiClient(URLSession: .shared)
        )
        
        viewModel.wikipediaPages
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { _, result, cell in
                cell.textLabel?.text = result.title
                cell.detailTextLabel?.text = result.url.absoluteString
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(WikipediaPage.self)
        .asDriver()
            .drive(onNext: { [weak self] searchResult in
                guard let self = self else { return }
                
                let safariViewController = SFSafariViewController(url: searchResult.url)
                self.present(safariViewController, animated: true, completion: nil)
            })
        .disposed(by: disposeBag)
        
    }
}
