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

final class TopEntryViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
    }
    
    private lazy var viewModel = TopEntryViewModel(searchBarText: searchBar.rx.text.asObservable(), searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(), model: TopEntryModel())
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        viewModel.reloadData
        .bind(to: reloadData)
        .disposed(by: disposeBag)
        
    }
    
    func setup() {
        tableView.rowHeight = 84
    }
}

extension TopEntryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TopEntryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TopEntryTableViewCell", for: indexPath) as! TopEntryTableViewCell
        cell.titleLabel.text = viewModel.entries[indexPath.row].value.description
        return cell
    }
    
}

extension TopEntryViewController: UITableViewDelegate {
    
}

extension TopEntryViewController {
    
    private var reloadData: Binder<Void> {
        return Binder(self) { me, _ in
            me.tableView.reloadData()
        }
    }
}
