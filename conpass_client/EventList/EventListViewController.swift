//
//  EventListViewController.swift
//  conpass_client
//
//  Created by 中野湧仁 on 2019/09/14.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class EntryListViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    var entryUrl: String?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = entryUrl
    }
}
