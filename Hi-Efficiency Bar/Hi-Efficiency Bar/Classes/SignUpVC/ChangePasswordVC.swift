//
//  ChangePasswordVC.swift
//  Hi-Efficiency Bar
//
//  Created by QTS Coder on 01/06/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseViewController {

    @IBOutlet weak var txfOldPassword: UITextField!
    @IBOutlet weak var txfNewPassword: UITextField!
    @IBOutlet weak var txfConfirmPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doSave(_ sender: Any) {
        let OldpasswordDef = UserDefaults.standard.value(forKey: kPassword) as! String
        let Oldpassword = txfOldPassword.text!
        let password = txfNewPassword.text!
        let confirmpassword = txfConfirmPassword.text!
        if Oldpassword.isEmpty
        {
            self.showAlertMessage(message: ERROR_OLDPASSWORD)
            return
        }
        if Oldpassword != OldpasswordDef
        {
            self.showAlertMessage(message: ERROR_OLDPASSWORD_NOT_MATCH)
            return
        }
        
        if password.isEmpty
        {
            self.showAlertMessage(message: ERROR_NEWPASSWORD)
            return
        }
        if confirmpassword.isEmpty
        {
            self.showAlertMessage(message: ERROR_CONFIRM_NEW_PASSWORD)
            return
        }
        if password != confirmpassword
        {
            self.showAlertMessage(message: ERROR_PASSWORD_NEW_NOTMATCH)
            return
        }
        self.view.endEditing(true)
        CommonHellper.showBusy()
        let para = ["old_password": Oldpassword, "new_password": password]
        print(para)
        ManagerWS.shared.changePassword(para) { (success, error) in
            CommonHellper.hideBusy()
            if success!
            {
                UserDefaults.standard.setValue(password, forKey: kPassword)
                UserDefaults.standard.synchronize()
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.showAlertMessage(message: (error?.msg)!)
            }
        }
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

}

extension ChangePasswordVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfOldPassword
        {
            txfNewPassword.becomeFirstResponder()
        }
        else if textField == txfNewPassword
        {
            txfConfirmPassword.becomeFirstResponder()
        }
        else{
            txfConfirmPassword.resignFirstResponder()
        }
        return true
    }
}
