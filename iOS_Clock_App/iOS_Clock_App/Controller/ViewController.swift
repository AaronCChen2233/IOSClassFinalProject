//
//  ViewController.swift
//  iOS_Clock_App
//
//  Created by Aaron Chen on 2020-05-26.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**Just For test now*/
        view.backgroundColor = UIColor(named: "backgroundColor")
        let testLable = UILabel()
        testLable.text = "This is a test"
        view.addSubview(testLable)
        testLable.matchParent()

    }


}

