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
    @IBOutlet weak var btnSubmit: TransitionButton!
    var email = String()
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

    @IBAction func doSubmit(_ sender: Any) {
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
        btnSubmit.startAnimation() // 2: Then start the animation when the user tap the button
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            ManagerWS.shared.activeCodeForgot(param: pama, complete: { (success, error) in
                if success!
                {
                    self.removeLoadingView()
                    
                    self.btnSubmit.stopAnimation(animationStyle: .shake, completion: {
                        self.btnSubmit.setTitle("SUBMIT", for: .normal)
                        self.btnSubmit.setImage(UIImage.init(), for: .normal)
                    })
                    self.perform(#selector(self.successforgot), with: nil, afterDelay: 0.5)
                }
                else{
                    self.btnSubmit.setTitle("SUBMIT", for: .normal)
                    self.btnSubmit.stopAnimation(animationStyle: .shake, completion: {
                        self.removeLoadingView()
                    })
                    self.showAlertMessage(message: error)
                }
            })
        })
    }
}
