//
//  SoundTableViewController.swift
//  iOS_Clock_App
//
//  Created by Naoki Mita on 2020-05-30.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class SoundTableViewController: UITableViewController {

    private let sounds: [Sound] = Sound.getAllSounds()
    private var bombSoundEffect: AVAudioPlayer?
    var curSound: Sound!
    var didSelect: ((Sound) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sound"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = sounds[indexPath.row].name
        cell.accessoryType = sounds[indexPath.row].id == curSound.id ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        bombSoundEffect?.stop()
        let cur = tableView.cellForRow(at: indexPath)?.accessoryType
        tableView.cellForRow(at: indexPath)?.accessoryType = cur == UITableViewCell.AccessoryType.none ? .checkmark : .none
        curSound = sounds[indexPath.row]
        
        print(curSound.name)
        let path: String = Bundle.main.path(forResource: "\(curSound.name).mp3", ofType:nil)!
        print(path)
        let url = URL(fileURLWithPath: path)
        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect?.play()
        } catch {
            print("sound erorr.")
        }
        tableView.reloadData()
        didSelect?(curSound)
    }
}
