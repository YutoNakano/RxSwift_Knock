//
//  SearchViewController.swift
//  conpass_client
//
//  Created by 中野湧仁 on 2019/09/13.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import RxSwift

final class SearchEntryViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let password = PublishSubject<String>()
        let repeatedPassword = PublishSubject<String>()
        _ = Observable.combineLatest(password, repeatedPassword) { "\($0), \($1)"}
            .subscribe(onNext: { print("onNext: ", $0) })
        password.onNext("a")
        password.onNext("ab")
        repeatedPassword.onNext("A")
        repeatedPassword.onNext("AB")
        repeatedPassword.onNext("ABC")
        
        
        
    }
    
    
}

