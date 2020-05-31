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
    
    var timePicker : UIView!
    var cancelButton : UIButton!
    var startPauseButton : UIButton!
    
    var timeLable: UILabel!
    var expectedTimeLable : UILabel!
    //    var circularProgress : UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /**view setting*/
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        /**timePicker Setting*/
        let countDownTimerWithSecondsDatePicker = CountDownTimerWithSecondsDatePicker()
        timePicker = countDownTimerWithSecondsDatePicker.view
        
        /**cancelButton Setting*/
        cancelButton = UIButton(type: .system)
        cancelButton.frame = CGRect(x: 0, y: 0, width: buttonHeightAndWidth, height: buttonHeightAndWidth)
        cancelButton.backgroundColor = .gray
        cancelButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = CGFloat(buttonHeightAndWidth/2);
        cancelButton.alpha = 0.7
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        //        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        /**startPauseButton Setting*/
        startPauseButton = UIButton(type: .system)
        startPauseButton.frame = CGRect(x: 0, y: 0, width: buttonHeightAndWidth, height: buttonHeightAndWidth)
        startPauseButton.clipsToBounds = true
        startPauseButton.layer.cornerRadius = CGFloat(buttonHeightAndWidth/2);
        startPauseButton.alpha = 0.7
        //        startPauseButton.addTarget(self, action: #selector(startOrPause), for: .touchUpInside)
        
        setButtonUI()
        setCircleButtonPath()
        
        
        /**Add all view first*/
        view.addSubview(timePicker)
        view.addSubview(cancelButton)
        view.addSubview(startPauseButton)
        self.addChild(countDownTimerWithSecondsDatePicker)
        
        /**Set UIViews constraint*/
        timePicker.anchors(topAnchor: view.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: nil,size: CGSize(width: 0, height: 400))
        cancelButton.anchors(topAnchor: timePicker.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: nil, bottomAnchor: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), size: CGSize(width: buttonHeightAndWidth, height: buttonHeightAndWidth) )
        startPauseButton.anchors(topAnchor: timePicker.bottomAnchor, leadingAnchor: nil, trailingAnchor: view.trailingAnchor, bottomAnchor: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10), size: CGSize(width: buttonHeightAndWidth, height: buttonHeightAndWidth))
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
        cancelButton.layer.addSublayer(circleLayer)
        let circleLayer2 = CAShapeLayer()
        circleLayer2.path = circlePath.cgPath
        circleLayer2.fillColor =  UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0).cgColor
        circleLayer2.strokeColor = UIColor(named: "backgroundColor")?.resolvedColor(with: self.traitCollection).cgColor
        circleLayer2.lineWidth = 2
        startPauseButton.layer.addSublayer(circleLayer2)
    }
    
    func setButtonUI() {
        /**set buttonUI depend on which state*/
        if isRuning{
            startPauseButton.setTitle("Pause", for: .normal)
            startPauseButton.backgroundColor = UIColor(displayP3Red: 1, green: 0, blue: 0, alpha: 0.3)
            startPauseButton.setTitleColor(.red, for: .normal)
        }else{
            startPauseButton.setTitle("Start", for: .normal)
            startPauseButton.backgroundColor = UIColor(displayP3Red: 0, green: 1, blue: 0, alpha: 0.3)
            startPauseButton.setTitleColor(.green, for: .normal)
        }
    }
    
}
