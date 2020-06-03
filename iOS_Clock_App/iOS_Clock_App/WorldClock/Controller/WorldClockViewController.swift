//
//  WorldClockViewController.swift
//  iOS_Clock_App
//
//  Created by WendaLi on 2020-05-30.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit
import CoreData

class WorldClockViewController: UIViewController {
    private var worldClockTableView: UITableView!
    private var addButton: UIBarButtonItem!
    
    private let cellId = "cell"
    
    //Used in Cell display
    private var date = Date() {
        didSet {
            DispatchQueue.main.async {
                self.worldClockTableView.reloadData()
            }
        }
    }
    
    private let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())

    var container: NSPersistentContainer!
    
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        
        setupWorldClockTableView()
        
        loadExistedWorldClock()
        
        fetchZonesForAddWorldClockViewControllAndUpdateCoreData()
        
        startGCDTimer()
        
        //Once Add WorldClock, updateView
        NotificationCenter.default.addObserver(worldClockTableView!, selector: #selector(worldClockTableView.reloadData), name: WorldClocksController.worldClocksUpdatedNotification, object: nil)
    }
    
    private func setupNavigation() {
        navigationItem.title = "World Clock"
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "highlightOrange")
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(gotoAddClock))
        addButton.tintColor = UIColor(named: "highlightOrange")
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupWorldClockTableView() {
        worldClockTableView = UITableView()
        worldClockTableView.backgroundColor = .black
        worldClockTableView.dataSource = self
        worldClockTableView.delegate = self
        worldClockTableView.register(WorldClockTableViewCell.self, forCellReuseIdentifier: cellId)
        worldClockTableView.separatorColor = .gray
        view.addSubview(worldClockTableView)
        worldClockTableView.matchParent()
    }
    
    private func loadExistedWorldClock() {
        container.performBackgroundTask { context in
            context.perform {
                ManagedWorldClock.readAllWorldClock(in: context) { (zones) in
                    if let zones = zones {
                        DispatchQueue.main.async {
                            WorldClocksController.shared.worldClocks.worldClockList = zones
                        }
                    }
                }
            }
        }
    }
    
    private func fetchZonesForAddWorldClockViewControllAndUpdateCoreData() {
        TimeZoneRequest.shared.fetchCities { [weak self] (zones) in
            if let zones = zones {
                    if let diffs = self?.diffWithTheMostRecentZones(zones) {
                        self?.updateTimeZoneDatabase(with: diffs, completion: {
                            WorldClocksController.shared.zones.insert(contentsOf: diffs, at: 0)
                        })
                    }
            }
        }
    }
    
    fileprivate func startGCDTimer() {
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            self.date = Date()
        })
        // 判断是否取消，如果已经取消了，调用resume()方法时就会崩溃！！！
        if codeTimer.isCancelled { return }
        // 启动时间源
        codeTimer.resume()
    }
    
    private func diffWithTheMostRecentZones(_ zones: [Zone]) -> [Zone] {
        if WorldClocksController.shared.zones.count == 0 {
            return zones
        }
        return WorldClocksController.shared.zones.difference(from: zones)
    }
    
    private func updateTimeZoneDatabase(with zones: [Zone],  completion: @escaping() -> Void) {
        container.performBackgroundTask { context in
            context.perform {
                for zone in zones {
                    _ = try? ManagedTimeZone.findOrCreateTimeZone(matching: zone, with: zone.zoneName, in: context)
                }
                try? context.save()
                completion()
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
      super.setEditing(editing, animated: animated)
        worldClockTableView.setEditing(editing, animated: true)
    }
    
    @objc func gotoAddClock(_ sender: UIBarButtonItem) {
        let rootViewController = AddClockViewController()
        rootViewController.container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        let addVC = UINavigationController(rootViewController: rootViewController)
        present(addVC, animated: true, completion: nil)
    }
}

extension WorldClockViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorldClocksController.shared.worldClocks.worldClockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WorldClockTableViewCell
        let city = WorldClocksController.shared.worldClocks.worldClockList[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = .black
                
        let calendar = Calendar.current
        let currHour = calendar.component(.hour, from: date)
        let currMinutes = calendar.component(.minute, from: date)
        let calHour = currHour + ((city.gmtOffset/3600)-8)
        let hour = calHour > 0 ? calHour % 24 : (calHour + 24) % 24
        let hourString = hour < 10 ? "0\(hour)" : "\(hour)"
        let minutesString = currMinutes < 10 ? "0\(currMinutes)" : "\(currMinutes)"
        let differ = calHour < 0 ? "Yestoday, \((city.gmtOffset/3600)-8)" : calHour >= 24 ? "Tomorow, \((city.gmtOffset/3600)-8)" : "Today, \((city.gmtOffset/3600)-8)"
        let zoneName = city.zoneName.split(separator: "/")
        let cityName = zoneName[1]
        
        cell.timeLable.text =  "\(hourString):\(minutesString)"
        cell.timeDifferenceLable.text = "\(differ)HR"
        cell.cityLabel.text = String(cityName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension WorldClockViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            WorldClocksController.shared.worldClocks.worldClockList.remove(at: indexPath.row)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
}

