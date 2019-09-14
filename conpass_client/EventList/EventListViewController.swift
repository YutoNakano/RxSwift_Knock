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

final class EventListViewController: UIViewController {
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}
