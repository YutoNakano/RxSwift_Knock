//
//  TopViewController.swift
//  conpass_client
//
//  Created by 中野湧仁 on 2019/09/13.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import RxSwift

final class TopEntryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = TopEntryViewModel(model: TopEntryModel())
    }
}

extension TopEntryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TopEntryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TopEntryTableViewCell", for: indexPath) as! TopEntryTableViewCell
        return cell
    }
    
}

extension TopEntryViewController: UITableViewDelegate {
    
}
