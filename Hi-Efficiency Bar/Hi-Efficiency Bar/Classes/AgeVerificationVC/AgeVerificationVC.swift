//
//  AgeVerificationVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class AgeVerificationVC: BaseViewController {

    @IBOutlet weak var txfBirthday: UITextField!
    var pickerView = PickerView.init(frame: .zero)
    @IBOutlet weak var btnConfirm: SSSpinnerButton!
    var userID = Int()
    var token = String()
    var birthday = String()
    var isLogin = false
    override func viewDidLoad() {
        super.viewDidLoad()
        btnConfirm.spinnerColor = .white
        txfBirthday.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doBirthday(_ sender: Any) {
        self.view.endEditing(true)
        pickerView = Bundle.main.loadNibNamed("PickerView", owner: self, options: nil)?[0] as! PickerView
        pickerView.delegate = self
        pickerView.frame = UIScreen.main.bounds
        APP_DELEGATE.window?.addSubview(pickerView)
        AnimationManager.sharedInstance().doAppearView(fromBottom: pickerView)
    }
    /*
     
    */
    @IBAction func actionConfirm(_ sender: SSSpinnerButton) {
        if CommonHellper.trimSpaceString(txtString: txfBirthday.text!).isEmpty
        {
            self.showAlertMessage(message: "Invalid date of birth")
            return
        }
        let arrs = CommonHellper.trimSpaceString(txtString: txfBirthday.text!).components(separatedBy: "-")
        let mothBirthday:Int? = Int(arrs[0])
        if mothBirthday! > 12
        {
            self.showAlertMessage(message: "Invalid date of birth")
            return
        }
        if isLogin
        {
            let calendar = Calendar.current
            let now = Date()
            let unitFlags = Set<Calendar.Component>([.day, .month, .year, .hour])
            let ageComponents = calendar.dateComponents(unitFlags, from: CommonHellper.formatStringToDateBirthday(date: self.convertDateBirthday()), to: now)
            let age = ageComponents.year!
            print(age)
            if age < 21
            {
                self.showAlertMessage(message: "Must be over 21 to use")
                return
            }
            sender.setBackgroundImage(#imageLiteral(resourceName: "color_tim"), for: .normal)
            sender.startAnimate(spinnerType: .circleStrokeSpin, spinnercolor: .white, complete: nil)
            self.perform(#selector(self.actionTabbar), with: nil, afterDelay: 0.25)
        }
        else{
            if self.convertDateBirthday() == birthday
            {
                let calendar = Calendar.current
                let now = Date()
                let unitFlags = Set<Calendar.Component>([.day, .month, .year, .hour])
                print(CommonHellper.formatStringToDateBirthday(date: birthday))
                let ageComponents = calendar.dateComponents(unitFlags, from: CommonHellper.formatStringToDateBirthday(date: birthday), to: now)
                let age = ageComponents.year!
                print(age)
                if age < 21
                {
                    self.showAlertMessage(message: "Must be over 21 to use")
                    return
                }
                UserDefaults.standard.set(self.userID, forKey: kID)
                UserDefaults.standard.set(self.token, forKey: kToken)
                UserDefaults.standard.set(self.token, forKey: kLoginApp)
                UserDefaults.standard.synchronize()
                sender.setBackgroundImage(#imageLiteral(resourceName: "color_tim"), for: .normal)
                sender.startAnimate(spinnerType: .circleStrokeSpin, spinnercolor: .white, complete: nil)
                self.perform(#selector(self.actionTabbar), with: nil, afterDelay: 0.25)
                
            }
            else{
                self.showAlertMessage(message: "Wrong date of birthday")
            }
        }
        
     
    }
    @objc func actionTabbar()
    {
        self.btnConfirm.stopAnimate(complete: {
            self.btnConfirm.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
            self.btnConfirm.setTitle("", for: .normal)
            self.btnConfirm.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
            APP_DELEGATE.initTabbarHome()
        })
        
    }
}
extension AgeVerificationVC: PickerViewDelegate
{
    func tapCancelPicker() {
        AnimationManager.sharedInstance().doDisappearView(toBottom: pickerView)
    }
    
    func tapDonePicker(value: Date) {
        txfBirthday.text = CommonHellper.formatDateBirthday(date: value)
        AnimationManager.sharedInstance().doDisappearView(toBottom: pickerView)
    }
    
    func convertDateBirthday()->String
    {
        let birthday = CommonHellper.trimSpaceString(txtString: txfBirthday.text!)
        let arrs = birthday.components(separatedBy: "-")
        if arrs.count == 3
        {
            return "\(arrs[2])-\(arrs[0])-\(arrs[1])"
        }
        else{
            return birthday
        }
    }
}

extension AgeVerificationVC: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Format Date of Birth dd-MM-yyyy
        
        //initially identify your textfield
        
        if textField == txfBirthday {
            
            // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
            if (txfBirthday?.text?.characters.count == 2) || (txfBirthday?.text?.characters.count == 5) {
                //Handle backspace being pressed
                if !(string == "") {
                    // append the text
                    txfBirthday?.text = (txfBirthday?.text)! + "-"
                }
            }
            // check the condition not exceed 9 chars
            return !(textField.text!.characters.count > 9 && (string.characters.count ) > range.length)
        }
        else {
            return true
        }
    }
}
