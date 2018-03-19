//
//  PickerView.swift
//  projectX
//
//  Created by Colin Ngo on 2/26/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
protocol PickerViewDelegate {
    func tapCancelPicker()
    func tapDonePicker(value: Date)
}
class PickerView: UIView {
    var delegate: PickerViewDelegate?
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
    }
 

    @IBAction func doCancel(_ sender: Any) {
        self.delegate?.tapCancelPicker()
      
    }
    @IBAction func doDone(_ sender: Any) {
       self.delegate?.tapDonePicker(value: datePicker.date)
       
    }
}
