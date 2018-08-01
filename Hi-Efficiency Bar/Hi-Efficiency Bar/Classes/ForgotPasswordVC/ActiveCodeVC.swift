//
//  ActiveCodeVC.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 24/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
class ActiveCodeVC: BaseViewController {

    @IBOutlet weak var txfCode: UITextField!
    @IBOutlet weak var txfNewPassword: UITextField!
    @IBOutlet weak var btnSubmit: SSSpinnerButton!
    var email = String()
    var timer: Timer?
    var indexSecond = 0.0
    var isSuccess = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func successforgot()
    {
                let alert = UIAlertController(title: APP_NAME,
                                              message: "Your new password has been updated.",
                                              preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction.init(title: "OK", style: .cancel) { (success) in
                    APP_DELEGATE.initTabbarHome()
                }
        
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func timeSecond()
    {
        indexSecond = indexSecond + 0.1
        if indexSecond == MAX_SECOND
        {
            if isSuccess
            {
                print("SUCCESS")
                timer?.invalidate()
                timer = nil
                if success!
                {
                    self.btnSubmit.stopAnimate(complete: {
                        self.removeLoadingView()
                        self.btnSubmit.alpha = 0.1
                        UIView.animate(withDuration: 0.5, animations: {
                            self.btnSubmit.alpha = 1.0
                            self.btnSubmit.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
                            self.btnSubmit.setTitle("", for: .normal)
                            self.btnSubmit.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                        }, completion: { (success) in
                            
                            self.perform(#selector(self.successforgot), with: nil, afterDelay: 0.5)
                        })
                    })
                }
                else{
                    
                    btnSubmit.stopAnimate(complete: {
                        self.removeLoadingView()
                        self.btnSubmit.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
                        self.btnSubmit.setTitle("SUBMIT", for: .normal)
                    })
                    self.showAlertMessage(message: self.error!)
                }
                
            }
            else{
                indexSecond =  0.1
            }
        }
    }
    var success: Bool?
    var error: String?
    
    @IBAction func doSubmit(_ sender: SSSpinnerButton) {
        let code = CommonHellper.trimSpaceString(txtString: txfCode.text!)
        let passcode = txfNewPassword.text!
        if code.isEmpty
        {
            self.showAlertMessage(message: ERROR_CODE)
            return
        }
        if passcode.isEmpty
        {
            self.showAlertMessage(message: ERROR_NEWPASSWORD)
            return
        }
        self.view.endEditing(true)
        let pama = ["email": email, "code": code,"password":passcode]
        self.addLoadingView()
        sender.setBackgroundImage(#imageLiteral(resourceName: "color_tim"), for: .normal)
        sender.startAnimate(spinnerType: .circleStrokeSpin, spinnercolor: .white, complete: nil)
        indexSecond = 0.1
        self.isSuccess = false
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timeSecond), userInfo: nil, repeats: true)
        ManagerWS.shared.activeCodeForgot(param: pama, complete: { (success, error) in
            self.success = success
            self.isSuccess = true
            self.error = error
            
        })
      
    }
}
