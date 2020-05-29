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
    let buttonHeightAndWidth = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /**view setting*/
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        /**timeGoesLable Setting*/
        timeGoesLable = UILabel()
        timeGoesLable.text = "00:00.00"
        timeGoesLable.textAlignment = .center
        timeGoesLable.font = UIFont.systemFont(ofSize: 90)
        
        /**lapButton Setting*/
        lapButton = UIButton(type: .system)
        lapButton.frame = CGRect(x: 0, y: 0, width: buttonHeightAndWidth, height: buttonHeightAndWidth)
        lapButton.setTitle("Lap", for: .normal)
        lapButton.backgroundColor = .gray
        lapButton.clipsToBounds = true
        lapButton.layer.cornerRadius = CGFloat(buttonHeightAndWidth/2);
        lapButton.alpha = 0.7
        lapButton.setTitleColor(.white, for: .normal)
        
        /**stopButton Setting*/
        startStopButton = UIButton(type: .system)
        startStopButton.frame = CGRect(x: 0, y: 0, width: buttonHeightAndWidth, height: buttonHeightAndWidth)
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.backgroundColor = UIColor(displayP3Red: 1, green: 0, blue: 0, alpha: 0.5)
        startStopButton.clipsToBounds = true
        startStopButton.layer.cornerRadius = CGFloat(buttonHeightAndWidth/2);
        startStopButton.alpha = 0.7
        startStopButton.setTitleColor(.red, for: .normal)
        
        setCircleButtonPath()
        
        /**lapTableView Setting*/
        lapTableView = UITableView()
        lapTableView.backgroundColor = UIColor(named: "backgroundColor")
        
        /**Add all view first*/
        view.addSubview(timeGoesLable)
        view.addSubview(lapButton)
        view.addSubview(startStopButton)
        view.addSubview(lapTableView)
        
        /**Set constraint*/
        timeGoesLable.anchors(topAnchor: view.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: nil,size: CGSize(width: 0, height: 400))
        
        lapButton.anchors(topAnchor: timeGoesLable.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: nil, bottomAnchor: nil, size: CGSize(width: buttonHeightAndWidth, height: buttonHeightAndWidth))
        
        startStopButton.anchors(topAnchor: timeGoesLable.bottomAnchor, leadingAnchor: nil, trailingAnchor: view.trailingAnchor, bottomAnchor: nil,size: CGSize(width: buttonHeightAndWidth, height: buttonHeightAndWidth))
        
        lapTableView.anchors(topAnchor: startStopButton.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setCircleButtonPath()
    }
    
    func setCircleButtonPath() {
        // TODO: - here if change mod so many time here will addsublayer so many time may have isuss check it later
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: buttonHeightAndWidth/2,y: buttonHeightAndWidth/2), radius: 46.0, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor =  UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0).cgColor
        circleLayer.strokeColor = UIColor(named: "backgroundColor")?.resolvedColor(with: self.traitCollection).cgColor
        circleLayer.lineWidth = 2
        lapButton.layer.addSublayer(circleLayer)
        let circleLayer2 = CAShapeLayer()
        circleLayer2.path = circlePath.cgPath
        circleLayer2.fillColor =  UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0).cgColor
        circleLayer2.strokeColor = UIColor(named: "backgroundColor")?.resolvedColor(with: self.traitCollection).cgColor
        circleLayer2.lineWidth = 2
        startStopButton.layer.addSublayer(circleLayer2)
    }
}
