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
    @IBOutlet weak var btnConfirm: TransitionButton!
    var userID = Int()
    var token = String()
    var birthday = String()
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
    @IBAction func actionConfirm(_ sender: TransitionButton) {
        if CommonHellper.trimSpaceString(txtString: txfBirthday.text!) == birthday
        {
            UserDefaults.standard.set(self.userID, forKey: kID)
           UserDefaults.standard.set(self.token, forKey: kToken)
            UserDefaults.standard.synchronize()
            btnConfirm.startAnimation()
            
            let qualityOfServiceClass = DispatchQoS.QoSClass.background
            let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
            backgroundQueue.async(execute: {
                
                sleep(1) // 3: Do your networking task or background work here.
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.btnConfirm.setTitle("", for: .normal)
                    self.btnConfirm.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                    self.btnConfirm.stopAnimation(animationStyle: .shake, completion: {
                        
                        
                    })
                    self.perform(#selector(self.actionTabbar), with: nil, afterDelay: 0.5)
                })
            })
        }
        else{
            self.showAlertMessage(message: "Wrong date of birthday")
        }
     
    }
    @objc func actionTabbar()
    {
        APP_DELEGATE.initTabbarHome()
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
}

extension AgeVerificationVC: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Format Date of Birth dd-MM-yyyy
        
        //initially identify your textfield
        
        if textField == txfBirthday {
            
            // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
            if (txfBirthday?.text?.characters.count == 4) || (txfBirthday?.text?.characters.count == 7) {
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
