//
//  ForgotPasswordVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import Alamofire
class ForgotPasswordVC: BaseViewController {

    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var btnReset: SSSpinnerButton!
    override func viewDidLoad() {
        super.viewDidLoad()

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

    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doResetPassword(_ sender: SSSpinnerButton) {
        let email = CommonHellper.trimSpaceString(txtString: txfEmail.text!)
        if email.isEmpty
        {
            self.showAlertMessage(message: ERROR_EMAIL)
            return
        }
        if !CommonHellper.isValidEmail(testStr: email)
        {
            self.showAlertMessage(message: ERROR_EMAIL_INVALID)
            return
        }
        self.txfEmail.resignFirstResponder()
        let para = ["email":email]
        self.addLoadingView()
        sender.setBackgroundImage(#imageLiteral(resourceName: "color_tim"), for: .normal)
        sender.startAnimate(spinnerType: .circleStrokeSpin, spinnercolor: .white, complete: nil)
        ManagerWS.shared.forgotPassword(para: para, complete: { (success) in
            if success!
            {
                self.removeLoadingView()
                
                 sender.stopAnimate(complete: {
                    sender.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
                    self.btnReset.setTitle("", for: .normal)
                    self.btnReset.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                })
                self.perform(#selector(self.successforgot), with: nil, afterDelay: 0.5)
            }
            else{
                
                sender.stopAnimate(complete: {
                    self.btnReset.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
                    self.btnReset.setTitle("RESET MY PASSWORD", for: .normal)
                    self.removeLoadingView()
                })
                self.showAlertMessage(message: "The email is not existed, please try again")
            }
        })
       
    }
    
    @objc func successforgot()
    {
        self.btnReset.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
        self.btnReset.setTitle("RESET MY PASSWORD", for: .normal)
        let email = CommonHellper.trimSpaceString(txtString: txfEmail.text!)
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ActiveCodeVC") as! ActiveCodeVC
        vc.email = email
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
