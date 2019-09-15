//
//  TopViewController.swift
//  conpass_client
//
//  Created by 中野湧仁 on 2019/09/13.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

struct User {
    let name: String
}

final class TopEntryViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
    }
    
    private let allUsers = [
        User(name: "かとう"),
        User(name: "たなか"),
        User(name: "ひらや"),
        User(name: "おおはし"),
        User(name: "やまもと"),
        User(name: "ふかさわ"),
        User(name: "さいとう"),
        User(name: "くどう"),
        User(name: "すわ"),
        User(name: "わたなべ")
    ]
    
    private var filteredUsers = [User]()
    
    
    private lazy var viewModel = TopEntryViewModel(searchBarText: searchBar.rx.text.asObservable(), searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(), itemSelected: tableView.rx.itemSelected.asObservable(),
        model: TopEntryModel()
    )
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        viewModel.reloadData
        .bind(to: reloadData)
        .disposed(by: disposeBag)
        
        viewModel.deselectRow
        .bind(to: deselectRow)
        .disposed(by: disposeBag)
        
        viewModel.transitionToEntry
        .bind(to: transitionToEntry)
        .disposed(by: disposeBag)
        
        setupSearchBar()
        
    }
    
    func setup() {
        tableView.rowHeight = 84
        searchBar.delegate = self
    }
}

extension TopEntryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.entries.count
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TopEntryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TopEntryTableViewCell", for: indexPath) as! TopEntryTableViewCell
//        let entry = viewModel.entries[indexPath.row]

//        cell.titleLabel.text = entry.description
//        cell.thumbnail.image = UIImage(urlString: entry.image.thumbnail.contentUrl)
        cell.textLabel?.text = filteredUsers[indexPath.row].name
        return cell
    }
    
}

extension TopEntryViewController: UITableViewDelegate {
    
}

extension TopEntryViewController {
    
    func setupSearchBar() {
        let debouncetime: RxTimeInterval = .microseconds(300)
        let incrementalSearchTextObservable = rx
            .methodInvoked(#selector(UISearchBarDelegate.searchBar(_:shouldChangeTextIn:replacementText:)))
            .debounce(debouncetime, scheduler: MainScheduler.instance)
            .flatMap { [unowned self] _ in
                Observable.just(self.searchBar.text ?? "")
        }                                      // 空文字やnilはオブザーブしない
        let textObservable = searchBar.rx.text.orEmpty.asObservable()
        let searchTextObservable = Observable.merge(incrementalSearchTextObservable, textObservable)
            .skip(1)
            .debounce(debouncetime, scheduler: MainScheduler.instance)
            // 変化があるまでイベントを発行しない
            .distinctUntilChanged()
        
        searchTextObservable.subscribe(onNext: { [unowned self] text in
            if text.isEmpty {
                self.filteredUsers = self.allUsers
            } else {
                self.filteredUsers = self.allUsers.filter { $0.name.contains(text) }
            }
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private var reloadData: Binder<Void> {
        return Binder(self) { me, _ in
            me.tableView.reloadData()
        }
    }
    
    private var deselectRow: Binder<IndexPath> {
        return Binder(self) { me, indexPath in
            me.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private var transitionToEntry: Binder<Entry.Value.Thmbnail.ImageDetails>  {
        return Binder(self) { [weak self] me, imageDetail in
            let storyboard = UIStoryboard(name: "EventList", bundle: nil).instantiateInitialViewController() as! EntryListViewController
            storyboard.entryUrl = imageDetail.contentUrl
            self?.navigationController?.pushViewController(storyboard, animated: true)
        }
    }
}

extension TopEntryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}

extension UIImage {
    convenience init(urlString: String) {
        let url = URL(string: urlString)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print(err)
        }
        self.init()
    }
}
