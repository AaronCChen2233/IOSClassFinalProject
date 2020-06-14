//
//  TimerViewController.swift
//  iOS_Clock_App
//
//  Created by Aaron Chen on 2020-05-29.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit
import UICircularProgressRing
import AVFoundation

import UserNotifications

class TimerViewController: UIViewController {
    let buttonHeightAndWidth = 100
    var isRuning = false
    var isPause = false
    var leftSeconds = 0
    var timer = Timer()
    var bombSoundEffect : AVAudioPlayer?
    var sound : Sound = Sound.getAllSounds().first!
    
    let countDownTimerWithSecondsDatePicker = CountDownTimerWithSecondsDatePicker()
    var timePicker : UIView!
    var cancelButton : UIButton!
    var startPauseButton : UIButton!
    var timeStackView : UIStackView!
    var expectedTimeStackView : UIStackView!
    let bellImageView : UIImageView = {
        let imv = UIImageView(image: UIImage(systemName: "bell.fill"))
        imv.tintColor = .gray
        return imv
    }()
    var timeLable : UILabel!
    var expectedTimeLable : UILabel!
    var circularProgress : UICircularProgressRing!
    
    let whenEndView = UIView()
    var whenEndButton : UIButton!
    var soundNameLable : UILabel!
    let rightImageView : UIImageView = {
        let imv = UIImageView(image: UIImage(systemName: "chevron.right"))
        imv.tintColor = .gray
        return imv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /**view setting*/
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        /**timePicker Setting*/
        timePicker = countDownTimerWithSecondsDatePicker.view
        
        /**cancelButton Setting*/
        cancelButton = UIButton(type: .system)
        cancelButton.frame = CGRect(x: 0, y: 0, width: buttonHeightAndWidth, height: buttonHeightAndWidth)
        cancelButton.backgroundColor = .lightGray
        cancelButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = CGFloat(buttonHeightAndWidth/2);
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        /**startPauseButton Setting*/
        startPauseButton = UIButton(type: .system)
        startPauseButton.frame = CGRect(x: 0, y: 0, width: buttonHeightAndWidth, height: buttonHeightAndWidth)
        startPauseButton.clipsToBounds = true
        startPauseButton.layer.cornerRadius = CGFloat(buttonHeightAndWidth/2);
        startPauseButton.alpha = 0.7
        startPauseButton.addTarget(self, action: #selector(startOrPause), for: .touchUpInside)
        
        setButtonUI()
        setCircleButtonPath()
        
        /**timeLable Setting*/
        timeLable = UILabel()
        timeLable.text = "00:00:00"
        timeLable.textAlignment = .center
        /**Set CourierNewPSMT because this fontFamily has same char width*/
        timeLable.font = UIFont(name: "CourierNewPSMT", size: 50)
        
        /**expectedTimeLable Setting*/
        expectedTimeLable = UILabel()
        expectedTimeLable.textAlignment = .center
        expectedTimeLable.textColor = .gray
        
        /**timeStackView and expectedTimeStackView Setting*/
        expectedTimeStackView = UIStackView(arrangedSubviews: [bellImageView, expectedTimeLable])
        expectedTimeStackView.axis = .horizontal
        expectedTimeStackView.alignment = .center
        expectedTimeStackView.backgroundColor = UIColor(named: "backgroundColor")
        
        timeStackView = UIStackView(arrangedSubviews: [timeLable, expectedTimeStackView])
        timeStackView.axis = .vertical
        timeStackView.alignment = .center
        timeStackView.backgroundColor = UIColor(named: "backgroundColor")
        
        /**circularProgress Setting*/
        circularProgress = UICircularProgressRing()
        circularProgress.startAngle = 270
        circularProgress.innerRingColor = UIColor(named: "highlightOrange")!
        circularProgress.outerRingColor = .lightGray
        circularProgress.fontColor = UIColor(named: "backgroundColor")!
        circularProgress.innerRingWidth = 10
        circularProgress.minValue = 0
        circularProgress.style = .ontop
        
        updateTimeUI()
        
        /**whenEndView group Setting*/
        whenEndButton = UIButton(type: .system)
        whenEndButton.addTarget(self, action: #selector(selectWhenEndAction), for: .touchUpInside)
        whenEndButton.setTitle("When Timer Ends", for: .normal)
        whenEndButton.setTitleColor(.white, for: .normal)
        whenEndButton.contentHorizontalAlignment = .left;
        whenEndButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

        soundNameLable = UILabel()
        soundNameLable.textColor = .gray
        
        /**set sound text*/
        soundNameLable.text = sound.name.rawValue
        
        whenEndView.layer.cornerRadius = CGFloat(10);
        whenEndView.backgroundColor = .lightGray
        whenEndView.addSubview(whenEndButton)
        whenEndView.addSubview(soundNameLable)
        whenEndView.addSubview(rightImageView)
        
        whenEndButton.matchParent()
        soundNameLable.anchors(topAnchor: whenEndView.topAnchor, leadingAnchor: nil, trailingAnchor: rightImageView.leadingAnchor, bottomAnchor: whenEndView.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        soundNameLable.centerYAnchor.constraint(equalTo: whenEndView.centerYAnchor).isActive = true
        rightImageView.anchors(topAnchor: nil, leadingAnchor: nil, trailingAnchor: whenEndView.trailingAnchor, bottomAnchor: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), size: CGSize(width: 0, height: soundNameLable.frame.height))
        rightImageView.centerYAnchor.constraint(equalTo: whenEndView.centerYAnchor).isActive = true
        
        /**Add all view first*/
        view.addSubview(circularProgress)
        view.addSubview(timeStackView)
        view.addSubview(timePicker)
        view.addSubview(cancelButton)
        view.addSubview(startPauseButton)
        view.addSubview(whenEndView)
        
        /**Add Child*/
        self.addChild(countDownTimerWithSecondsDatePicker)
        
        /**Set UIViews constraint*/
        timePicker.anchors(topAnchor: view.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: nil,size: CGSize(width: 0, height: 400))
        timeStackView.anchors(topAnchor: view.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: nil,padding: UIEdgeInsets(top: 180, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 150))
        circularProgress.anchors(topAnchor: view.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: nil,padding: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 380))
        cancelButton.anchors(topAnchor: timePicker.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: nil, bottomAnchor: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), size: CGSize(width: buttonHeightAndWidth, height: buttonHeightAndWidth) )
        startPauseButton.anchors(topAnchor: timePicker.bottomAnchor, leadingAnchor: nil, trailingAnchor: view.trailingAnchor, bottomAnchor: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10), size: CGSize(width: buttonHeightAndWidth, height: buttonHeightAndWidth))
        whenEndView.anchors(topAnchor: cancelButton.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: nil, padding: UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 50))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setCircleButtonPath()
    }
    
    @objc func cancel(){
        if isRuning {
            cancelTimer()
        }
    }
    
    @objc func startOrPause(){
        /**If user didn't select any time just return*/
        guard !countDownTimerWithSecondsDatePicker.isZero else {
            return
        }
        
        if isPause {
            /**Pause*/
            timer.invalidate()
        }else{
            /**Start*/
            /**If isn't runing reset leftSeconds if isruning just keep leftSeconds and resume*/
            if !isRuning{
                start()
            }
            
            /**Resume*/
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDownUI), userInfo: nil, repeats: true)
            
            let date = Date()
            let calendar = Calendar.current
            let exceptTime = calendar.date(byAdding: .second, value: leftSeconds, to: date)
            
            let formatter = DateFormatter()
            formatter.dateFormat = " h:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            expectedTimeLable.text = formatter.string(from: exceptTime!)
        }
        
        isPause.toggle()
        isRuning = true
        updateTimeUI()
        setButtonUI()
    }
    
    @objc func updateCountDownUI(){
        /**Converte fractions to minute second and fractions*/
        let h = Int(leftSeconds/3600)
        let m = Int((leftSeconds-(h*3600))/60)
        let s = leftSeconds % 60
        timeLable.text = String(format: "%02d:%02d:%02d", h, m, s)
        
        if leftSeconds <= 0{
            /**Time 's up*/
            timer.invalidate()
            scheduleNotification()
        }
        circularProgress.value = CGFloat(leftSeconds)
        leftSeconds -= 1
    }
    
    @objc func selectWhenEndAction(){
        let selectSoundVC = SelectSoundTableViewController()
        selectSoundVC.curSound = sound
        selectSoundVC.didSelect = updateSound
        let navigationSelectionSoundVC = UINavigationController(rootViewController: selectSoundVC)
        navigationSelectionSoundVC.modalPresentationStyle = .fullScreen
        self.present(navigationSelectionSoundVC, animated: true)
    }
    
    func scheduleNotification() {
        /**Set notifiction select option*/
        let center = UNUserNotificationCenter.current()
        let acceptAction = UNNotificationAction(identifier: "STOP", title: "Stop", options: UNNotificationActionOptions(rawValue: 0))
        let declineAction = UNNotificationAction(identifier: "REPEAT", title: "Repeat", options: UNNotificationActionOptions(rawValue: 0))
        let meetingInviteCategory = UNNotificationCategory(identifier: "TimerTimesUp", actions: [acceptAction, declineAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        center.setNotificationCategories([meetingInviteCategory])
        
        center.delegate = self
        let content = UNMutableNotificationContent()
        content.title = "Timer"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(sound.name).mp3"))
        content.categoryIdentifier = "TimerTimesUp"
        let request = UNNotificationRequest(identifier: "timer-alarm", content: content, trigger: nil)
        center.add(request) { (error) in
            if (error) != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func setCircleButtonPath() {
        /// TODO: - here if change mod so many time here will addsublayer so many time may have isuss check it later
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
    
    func cancelTimer() {
        timer.invalidate()
        isRuning = false
        isPause = false
        updateTimeUI()
        setButtonUI()
    }
    
    func setButtonUI() {
        /**set buttonUI depend on which state*/
        if isPause {
            startPauseButton.setTitle("Pause", for: .normal)
            startPauseButton.backgroundColor = UIColor(named: "highlightOrange")!.withAlphaComponent(0.5)
            startPauseButton.setTitleColor(UIColor(named: "highlightOrange")!, for: .normal)
        }else{
            startPauseButton.setTitle("Start", for: .normal)
            startPauseButton.backgroundColor = UIColor(displayP3Red: 0, green: 1, blue: 0, alpha: 0.3)
            startPauseButton.setTitleColor(.green, for: .normal)
        }
    }
    
    func updateTimeUI(){
        if isRuning {
            timeStackView.isHidden = false
            circularProgress.isHidden = false
            countDownTimerWithSecondsDatePicker.view.isHidden = true
        }else{
            timeStackView.isHidden = true
            circularProgress.isHidden = true
            countDownTimerWithSecondsDatePicker.view.isHidden = false
        }
    }
    
    func start() {
        /**Corvert to seconds*/
        leftSeconds = (countDownTimerWithSecondsDatePicker.hour * 3600) + (countDownTimerWithSecondsDatePicker.min * 60) + countDownTimerWithSecondsDatePicker.sec
        
        circularProgress.maxValue = CGFloat(leftSeconds)
        /**when start tip set text once*/
        updateCountDownUI()
    }
    
    func updateSound(new: Sound) {
        sound = new
        soundNameLable.text = sound.name.rawValue
    }
}

/**Handling notifications when the app is in the foreground*/
extension TimerViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "STOP":
            cancelTimer()
            break
        case "REPEAT":
            start()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDownUI), userInfo: nil, repeats: true)
            break
        default:
             cancelTimer()
            break
        }
        
        completionHandler()
    }
}
