//
//  StopwatchViewController.swift
//  iOS_Clock_App
//
//  Created by Aaron Chen on 2020-05-27.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit
// TODO: - refatering

class StopwatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let buttonHeightAndWidth = 100
    let cellId = "Cell"
    var fractions = 0
    var isRuning = false
    var timer = Timer()
    var timeGoesLable : UILabel!
    var lapResetButton : UIButton!
    var startStopButton : UIButton!
    var lapTableView : UITableView!
    var lapDatas = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /**view setting*/
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        /**timeGoesLable Setting*/
        timeGoesLable = UILabel()
        timeGoesLable.text = "00:00.00"
        timeGoesLable.textAlignment = .center
        //        timeGoesLable.font = UIFont.systemFont(ofSize: 90)
        /**Set CourierNewPSMT because this fontFamily has same char width*/
        timeGoesLable.font = UIFont(name: "CourierNewPSMT", size: 85)
        
        /**lapButton Setting*/
        lapResetButton = UIButton(type: .system)
        lapResetButton.frame = CGRect(x: 0, y: 0, width: buttonHeightAndWidth, height: buttonHeightAndWidth)
        lapResetButton.backgroundColor = .gray
        lapResetButton.clipsToBounds = true
        lapResetButton.layer.cornerRadius = CGFloat(buttonHeightAndWidth/2);
        lapResetButton.alpha = 0.7
        lapResetButton.setTitleColor(.white, for: .normal)
        lapResetButton.addTarget(self, action: #selector(lapOrReset), for: .touchUpInside)
        
        /**stopButton Setting*/
        startStopButton = UIButton(type: .system)
        startStopButton.frame = CGRect(x: 0, y: 0, width: buttonHeightAndWidth, height: buttonHeightAndWidth)
        startStopButton.clipsToBounds = true
        startStopButton.layer.cornerRadius = CGFloat(buttonHeightAndWidth/2);
        startStopButton.alpha = 0.7
        startStopButton.addTarget(self, action: #selector(startOrStop), for: .touchUpInside)
        
        setButtonUI()
        setCircleButtonPath()
        
        /**lapTableView Setting*/
        lapTableView = UITableView()
        lapTableView.backgroundColor = UIColor(named: "backgroundColor")
        lapTableView.dataSource = self
        lapTableView.delegate = self
        lapTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        /**Add all view first*/
        view.addSubview(timeGoesLable)
        view.addSubview(lapResetButton)
        view.addSubview(startStopButton)
        view.addSubview(lapTableView)
        
        /**Set constraint*/
        timeGoesLable.anchors(topAnchor: view.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: nil,size: CGSize(width: 0, height: 400))
        
        lapResetButton.anchors(topAnchor: timeGoesLable.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: nil, bottomAnchor: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), size: CGSize(width: buttonHeightAndWidth, height: buttonHeightAndWidth) )
        
        startStopButton.anchors(topAnchor: timeGoesLable.bottomAnchor, leadingAnchor: nil, trailingAnchor: view.trailingAnchor, bottomAnchor: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10), size: CGSize(width: buttonHeightAndWidth, height: buttonHeightAndWidth))
        
        lapTableView.anchors(topAnchor: startStopButton.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setCircleButtonPath()
    }
    
    @objc func lapOrReset(){
        if isRuning{
            /**Lap*/
            lapDatas.append(timeGoesLable.text!)
            let newRow = IndexPath(row: lapDatas.count-1, section: 0)
            lapTableView.insertRows(at: [newRow], with: .automatic)
            
            /**scroll to bottom*/
            lapTableView.scrollToRow(at: newRow, at: .bottom, animated: true)
        }else{
            /**Reset*/
            timeGoesLable.text = "00:00.00"
            fractions = 0
            lapDatas = [String]()
            lapTableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
        }
    }
    
    @objc func startOrStop(){
        if isRuning {
            /**Stop*/
            timer.invalidate()
        }else{
            /**Start*/
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updatetimeGoesLable), userInfo: nil, repeats: true)
        }
        isRuning.toggle()
        setButtonUI()
    }
    
    @objc func updatetimeGoesLable(){
        fractions += 1
        /**Converte fractions to minute second and fractions*/
        let m = Int(fractions/6000)
        let s = Int((fractions-(m*6000))/100)
        let f = fractions % 100
        timeGoesLable.text = String(format: "%02d:%02d.%02d", m, s, f)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        cell.backgroundColor = UIColor(named: "backgroundColor")
        cell.textLabel?.text = "Lap \(indexPath.row + 1)"
        cell.detailTextLabel?.text = lapDatas[indexPath.row]
        
        return cell
    }
    
    func setCircleButtonPath() {
        // TODO: - here if change mod so many time here will addsublayer so many time may have isuss check it later
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: buttonHeightAndWidth/2,y: buttonHeightAndWidth/2), radius: 46.0, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor =  UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0).cgColor
        circleLayer.strokeColor = UIColor(named: "backgroundColor")?.resolvedColor(with: self.traitCollection).cgColor
        circleLayer.lineWidth = 2
        lapResetButton.layer.addSublayer(circleLayer)
        let circleLayer2 = CAShapeLayer()
        circleLayer2.path = circlePath.cgPath
        circleLayer2.fillColor =  UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0).cgColor
        circleLayer2.strokeColor = UIColor(named: "backgroundColor")?.resolvedColor(with: self.traitCollection).cgColor
        circleLayer2.lineWidth = 2
        startStopButton.layer.addSublayer(circleLayer2)
    }
    
    func setButtonUI() {
        if isRuning{
            lapResetButton.setTitle("Lap", for: .normal)
            
            startStopButton.setTitle("Stop", for: .normal)
            startStopButton.backgroundColor = UIColor(displayP3Red: 1, green: 0, blue: 0, alpha: 0.3)
            startStopButton.setTitleColor(.red, for: .normal)
        }else{
            lapResetButton.setTitle("Reset", for: .normal)
            
            startStopButton.setTitle("Start", for: .normal)
            startStopButton.backgroundColor = UIColor(displayP3Red: 0, green: 1, blue: 0, alpha: 0.3)
            startStopButton.setTitleColor(.green, for: .normal)
        }
    }
}


