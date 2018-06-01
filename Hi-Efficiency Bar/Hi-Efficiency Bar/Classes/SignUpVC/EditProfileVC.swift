//
//  EditProfileVC.swift
//  Hi-Efficiency Bar
//
//  Created by QTS Coder on 01/06/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import Alamofire
class EditProfileVC: BaseViewController {

    @IBOutlet weak var txfFirstName: UITextField!
    @IBOutlet weak var txfLastName: UITextField!
    var inforUser: NSDictionary?
    var userID = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.initData()
        // Do any additional setup after loading the view.
    }

    func initData()
    {
        if let firstname = self.inforUser?.object(forKey: "first_name") as? String
        {
            txfFirstName.text = firstname
        }
        if let last_name = self.inforUser?.object(forKey: "last_name") as? String
        {
            txfLastName.text = last_name
        }
        if let id = self.inforUser?.object(forKey: "id") as? Int
        {
            self.userID = id
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doSave(_ sender: Any) {
        let firsname = CommonHellper.trimSpaceString(txtString: txfFirstName.text!)
        let lastname = CommonHellper.trimSpaceString(txtString: txfLastName.text!)
        if firsname.isEmpty
        {
            self.showAlertMessage(message: ERROR_NAME)
            return
        }
        if lastname.isEmpty
        {
            self.showAlertMessage(message: ERROR_LASTNAME)
            return
        }
        self.view.endEditing(true)
        let para = ["first_name": firsname, "last_name": lastname]
        CommonHellper.showBusy()
        ManagerWS.shared.editProfile(para, self.userID) { (success, error) in
            CommonHellper.hideBusy()
            if success!
            {
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.showAlertMessage(message: (error?.msg)!)
            }
        }
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

extension EditProfileVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfFirstName
        {
            txfLastName.becomeFirstResponder()
        }
        else
        {
            txfLastName.resignFirstResponder()
        }
        return true
    }
}
