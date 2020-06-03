//
//  DatePickerTableViewCell.swift
//  HotelFormCode
//
//  Created by Derrick Park on 5/10/20.
//  Copyright © 2020 Derrick Park. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {
  
  let datePicker: UIDatePicker = {
    let dp = UIDatePicker()
    dp.translatesAutoresizingMaskIntoConstraints = false
    dp.datePickerMode = UIDatePicker.Mode.time
    dp.locale = Locale(identifier: "en_GB")
    return dp
  }()
  
  var datePickerValueChanged: (() -> ())?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(datePicker)
    datePicker.matchParent()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}
