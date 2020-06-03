//
//  WorldClockTableViewCell.swift
//  iOS_Clock_App
//
//  Created by WendaLi on 2020-05-30.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit

class WorldClockTableViewCell: UITableViewCell {

    let timeDifferenceLable: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 18)
        lb.textColor = .gray
        return lb
    }()
    
    let cityLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 30)
        lb.textColor = .white
        return lb
    }()
    
    let timeLable: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 55)
        lb.textColor = .white
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .black
        let vStackView = VerticalStackView(arrangedSubviews: [timeDifferenceLable, cityLabel], spacing: 5, distribution: .fillEqually)
        let hStackVie = HorizontalStackView(arrangedSubviews: [vStackView, timeLable], spacing: 10, distribution: .equalCentering)
        contentView.addSubview(hStackVie)
        hStackVie.anchors(topAnchor: contentView.topAnchor, leadingAnchor: contentView.leadingAnchor, trailingAnchor: contentView.trailingAnchor, bottomAnchor: contentView.bottomAnchor, padding: UIEdgeInsets(top: 22, left: 22, bottom: 22, right: 22), size: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
