//
//  SelectSoundTableViewController.swift
//  iOS_Clock_App
//
//  Created by Aaron Chen on 2020-06-04.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit
import AVFoundation

class SelectSoundTableViewController: UITableViewController {
    
    private let sounds: [Sound] = Sound.getAllSounds()
    private var bombSoundEffect: AVAudioPlayer?
    var curSound: Sound!
    var didSelect: ((Sound) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /**Add this line those empty cell will not show*/
        navigationItem.title = "When Timer Ends"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Set", style: .plain, target: self, action: #selector(setSound))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "highlightOrange")!
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "highlightOrange")!
        tableView.tableFooterView = UIView()
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func setSound(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        didSelect!(curSound)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = sounds[indexPath.row].name.rawValue
        cell.imageView?.image = UIImage(systemName: "checkmark")
        /**If is selected let the checkmark image become orange else transparent*/
        cell.imageView?.tintColor = sounds[indexPath.row].name == curSound.name ? UIColor(named: "highlightOrange")! : UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        bombSoundEffect?.stop()
        let cur = tableView.cellForRow(at: indexPath)?.accessoryType
        tableView.cellForRow(at: indexPath)?.accessoryType = cur == UITableViewCell.AccessoryType.none ? .checkmark : .none
        curSound = sounds[indexPath.row]
        
        let path: String = Bundle.main.path(forResource: "\(curSound.name).mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect?.play()
        } catch {
            print("sound erorr.")
        }
        tableView.reloadData()
    }
}
