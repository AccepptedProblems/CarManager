//
//  DatePickerViewCell.swift
//  CarManagement
//
//  Created by namnt on 8/25/20.
//  Copyright © 2020 namnt. All rights reserved.
//

import UIKit

class WeightViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    func setUI(titleString: String, placeholder: String, value: String) {
        title.text = titleString
        textField.placeholder = placeholder
        textField.text = value
    }
    
}

class ValidateCell: UITableViewCell {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleDate: UILabel!
    @IBOutlet weak var valueDate: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bottomView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpDate()
    }
    
    func setUI(title: String, value: String, status: Bool) {
        titleDate.text = title
        valueDate.text = value
        bottomView.isHidden = !status
    }
    
    @IBAction func datePickerChange(_ sender: UIDatePicker) {
        setUpDate()
    }
    
    func setUpDate() {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        valueDate.text = dateFormatter.string(from: datePicker.date)
    }
    
}


