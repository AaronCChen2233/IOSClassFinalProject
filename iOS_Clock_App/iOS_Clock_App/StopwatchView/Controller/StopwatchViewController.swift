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
    var lapFraction = 0
    
    var maxValue = 0 {
        didSet {
            changeMaxAndMinCellColor(oldValue)
            changeMaxAndMinCellColor(maxValue)
        }
    }
    
    var minValue = Int.max {
        didSet {
            changeMaxAndMinCellColor(oldValue)
            changeMaxAndMinCellColor(minValue)
        }
    }
    
    var isRuning = false
    var timer = Timer()
    var lapDatas = [Int]()
    var timeGoesLable : UILabel!
    var lapResetButton : UIButton!
    var startStopButton : UIButton!
    var lapTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /**view setting*/
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        /**timeGoesLable Setting*/
        timeGoesLable = UILabel()
        timeGoesLable.text = "00:00.00"
        timeGoesLable.textAlignment = .center
        /**Set CourierNewPSMT because this fontFamily has same char width*/
        timeGoesLable.font = UIFont(name: "CourierNewPSMT", size: 85)
        
        /**lapResetButton Setting*/
        lapResetButton = UIButton(type: .system)
        lapResetButton.frame = CGRect(x: 0, y: 0, width: buttonHeightAndWidth, height: buttonHeightAndWidth)
        lapResetButton.backgroundColor = .gray
        lapResetButton.clipsToBounds = true
        lapResetButton.layer.cornerRadius = CGFloat(buttonHeightAndWidth/2);
        lapResetButton.alpha = 0.7
        lapResetButton.setTitleColor(.white, for: .normal)
        lapResetButton.addTarget(self, action: #selector(lapOrReset), for: .touchUpInside)
        
        /**startStopButton Setting*/
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
        
        /**Set UIViews constraint*/
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
            lapDatas.insert(lapFraction, at: 0)
            
            let newRow = IndexPath(row: 0, section: 0)
            lapTableView.insertRows(at: [newRow], with: .none)
            setMaxAndMinValue()
            lapFraction = 0
        }else{
            /**Reset*/
            timeGoesLable.text = "00:00.00"
            fractions = 0
            lapFraction = 0
            maxValue = 0
            minValue = Int.max
            lapDatas = [Int]()
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
            
            if(fractions == 0){
                lapDatas.insert(lapFraction, at: 0)
                
                let newRow = IndexPath(row: 0, section: 0)
                lapTableView.insertRows(at: [newRow], with: .automatic)
                setMaxAndMinValue()
            }
        }
        isRuning.toggle()
        setButtonUI()
    }
    
    @objc func updatetimeGoesLable(){
        fractions += 1
        lapFraction += 1
        timeGoesLable.text = fractionToString(fractions)
        
        lapDatas[0] = lapFraction
        let newRow = IndexPath(row: 0, section: 0)
        lapTableView.reloadRows(at: [newRow], with: .none)
    }
    
    func setMaxAndMinValue(){
        /**keep max*/
        if maxValue < lapFraction{
            maxValue = lapFraction
        }
        
        /**keep min exept lapFraction != 0 because if say minValue is 0 there will always keep 0*/
        if minValue > lapFraction && lapFraction != 0{
            minValue = lapFraction
        }
    }
    
    func changeMaxAndMinCellColor(_ reloadValue: Int){
        /**only when lapDatas's count bigger than 2 will change color*/
        if lapDatas.count > 2{
            /**Because old minValue or maxValue maybe appeared more than one times, so use for loop to reload all old minValue or maxValue*/
            for i in 1...lapDatas.count-1{
                if lapDatas[i] == reloadValue{
                    let newRow = IndexPath(row: i, section: 0)
                    lapTableView.reloadRows(at: [newRow], with: .none)
                }
            }
        }
    }
    
    func fractionToString(_ inputFraction : Int) -> String{
        /**Converte fractions to minute second and fractions*/
        let m = Int(inputFraction/6000)
        let s = Int((inputFraction-(m*6000))/100)
        let f = inputFraction % 100
        return String(format: "%02d:%02d.%02d", m, s, f)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lapFractionDate = lapDatas[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        cell.backgroundColor = UIColor(named: "backgroundColor")
        /**Because the order is reverse so use lapDatas.count - indexPath.row*/
        cell.textLabel?.text = "Lap \(lapDatas.count - indexPath.row)"
        cell.detailTextLabel?.text = fractionToString(lapFractionDate)
        
        /**Set colors*/
        if lapFractionDate == maxValue{
            cell.textLabel?.textColor = .red
            cell.detailTextLabel?.textColor = .red
        }
        
        if lapFractionDate == minValue{
            cell.textLabel?.textColor = .green
            cell.detailTextLabel?.textColor = .green
        }
                
        return cell
    }
    
    func setCircleButtonPath() {
        /// TODO: - here if change mod so many time here will addsublayer so many time may have isuss check it later
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
        /**set buttonUI depend on which state*/
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
