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
    private var noClockLable: UILabel!
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
        //navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        //navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        setupNavigation()
        
        setupNoClockLabel()
        
        setupWorldClockTableView()
        
        loadExistedWorldClock()
        
        fetchZonesForAddWorldClockViewControllAndUpdateCoreData()
        
        startGCDTimer()
        
        //Once Add WorldClock, updateView
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: WorldClocksController.worldClocksUpdatedNotification, object: nil)
    }
    
    @objc private func updateUI() {
        if WorldClocksController.shared.worldClocks.worldClockList.count == 0 {
            worldClockTableView.isHidden = true
            noClockLable.isHidden = false
        }else {
            noClockLable.isHidden = true
            worldClockTableView.isHidden = false
            worldClockTableView.reloadData()
        }
    }
    
    private func setupNavigation() {
        navigationItem.title = "World Clock"
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "highlightOrange")
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(gotoAddClock))
        addButton.tintColor = UIColor(named: "highlightOrange")
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupNoClockLabel() {
        noClockLable = {
            let lb = UILabel()
            lb.translatesAutoresizingMaskIntoConstraints = false
            lb.font = UIFont.systemFont(ofSize: 30)
            lb.text = "No World Clocks"
            return lb
        }()
        view.addSubview(noClockLable)
        noClockLable.centerXYin(view)
    }
    
    private func setupWorldClockTableView() {
        worldClockTableView = UITableView()
        //worldClockTableView.backgroundColor = .black
        worldClockTableView.dataSource = self
        worldClockTableView.delegate = self
        worldClockTableView.register(WorldClockTableViewCell.self, forCellReuseIdentifier: cellId)
        //worldClockTableView.separatorColor = .gray
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
    
    private func configerCell(cell: WorldClockTableViewCell, forItemAt indexPath: IndexPath) {
        cell.selectionStyle = .none
        
        let zone = WorldClocksController.shared.worldClocks.worldClockList[indexPath.row]
        
        let secondsInOneHour = 3600
        let calendar = Calendar.current
        
        let currHour = calendar.component(.hour, from: date)
        let CurrGMTForDateInHour = calendar.timeZone.secondsFromGMT(for: date) / secondsInOneHour
        let zoneGmtOffsetInHour = zone.gmtOffset/secondsInOneHour
        let differHour = currHour - CurrGMTForDateInHour + zoneGmtOffsetInHour
        
        let differ = differHour < 0 ?
        "Yestoday, \(zoneGmtOffsetInHour - CurrGMTForDateInHour)" :
        differHour >= 24 ? "Tomorow, \(zoneGmtOffsetInHour - CurrGMTForDateInHour)" :
        "Today, \(zoneGmtOffsetInHour - CurrGMTForDateInHour)"
        
        let hour = differHour > 0 ? differHour % 24 : (differHour + 24) % 24
        let hourString = hour < 10 ? "0\(hour)" : "\(hour)"
        let currMinutes = calendar.component(.minute, from: date)
        let minutesString = currMinutes < 10 ? "0\(currMinutes)" : "\(currMinutes)"
        
        let zoneName = zone.zoneName.split(separator: "/")
        let cityName = zoneName[1]
        
        cell.timeLable.text =  "\(hourString):\(minutesString)"
        cell.timeDifferenceLable.text = "\(differ)HR"
        cell.cityLabel.text = String(cityName)
    }

    private func updateWorldClockDatabase(with zone: Zone) {
        container.performBackgroundTask { context in
            context.perform {
                _ = try? ManagedWorldClock.findAndDeleteWorldClock(matching: zone, with: zone.zoneName, in: context)
                try? context.save()
            }
        }
    }
}

extension WorldClockViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorldClocksController.shared.worldClocks.worldClockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WorldClockTableViewCell
        configerCell(cell: cell, forItemAt: indexPath)
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let zone = WorldClocksController.shared.worldClocks.worldClockList.remove(at: sourceIndexPath.row)
        WorldClocksController.shared.worldClocks.worldClockList.insert(zone, at: destinationIndexPath.row)
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
            let zone = WorldClocksController.shared.worldClocks.worldClockList[indexPath.row]
            WorldClocksController.shared.worldClocks.worldClockList.remove(at: indexPath.row)
            self.updateWorldClockDatabase(with: zone)
        }
    }
    
}

