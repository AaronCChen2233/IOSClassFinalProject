//
//  StopwatchViewController.swift
//  iOS_Clock_App
//
//  Created by Aaron Chen on 2020-05-27.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController {
    var timeGoesLable : UILabel!
    var lapButton : UIButton!
    var startStopButton : UIButton!
    var lapTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**timeGoesLable Setting*/
        timeGoesLable = UILabel()
        timeGoesLable.text = "00:00.00"
        timeGoesLable.textColor = .black
        timeGoesLable.textAlignment = .center
        
        /**lapButton Setting*/
        lapButton = UIButton(type: .system)
        lapButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        lapButton.setTitle("Lap", for: .normal)
        lapButton.backgroundColor = .gray
        lapButton.clipsToBounds = true
        lapButton.layer.cornerRadius = lapButton.bounds.size.width/2;
        
        /**stopButton Setting*/
        
        startStopButton = UIButton(type: .system)
        startStopButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        startStopButton.setTitle("Stop", for: .normal)
        startStopButton.backgroundColor = .red
        
        /**For circle Button*/
        startStopButton.clipsToBounds = true
        startStopButton.layer.cornerRadius = startStopButton.bounds.size.width/2;
        
        /**lapTableView Setting*/
        lapTableView = UITableView()
        
        /**Add all view first*/
        view.addSubview(timeGoesLable)
        view.addSubview(lapButton)
        view.addSubview(startStopButton)
        view.addSubview(lapTableView)
        
        /**Set constraint*/
        timeGoesLable.anchors(topAnchor: view.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: nil,size: CGSize(width: 0, height: 400))
        
        lapButton.anchors(topAnchor: timeGoesLable.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: nil, bottomAnchor: nil, size: CGSize(width: 100, height: 100))
        
        startStopButton.anchors(topAnchor: timeGoesLable.bottomAnchor, leadingAnchor: nil, trailingAnchor: view.trailingAnchor, bottomAnchor: nil,size: CGSize(width: 100, height: 100))
        
        lapTableView.anchors(topAnchor: startStopButton.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor)
        
        
    }
}
