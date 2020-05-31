//
//  TimerViewController.swift
//  iOS_Clock_App
//
//  Created by Aaron Chen on 2020-05-29.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    let buttonHeightAndWidth = 100
    var isRuning = false
    var timer = Timer()
    var timeGoesLable : UILabel!
    var lapResetButton : UIButton!
    var startStopButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /**view setting*/
           view.backgroundColor = UIColor(named: "backgroundColor")
    }

}
