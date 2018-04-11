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
    @IBOutlet weak var btnReset: TransitionButton!
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
    @IBAction func doResetPassword(_ sender: Any) {
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
        btnReset.startAnimation() // 2: Then start the animation when the user tap the button
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            ManagerWS.shared.forgotPassword(para: para, complete: { (success) in
                if success!
                {
                    self.removeLoadingView()
                    self.btnReset.setTitle("", for: .normal)
                    self.btnReset.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                    self.btnReset.stopAnimation(animationStyle: .shake, completion: {
                        
                        
                    })
                    self.perform(#selector(self.successforgot), with: nil, afterDelay: 0.5)
                }
                else{
                    self.btnReset.setTitle("RESET MY PASSWORD", for: .normal)
                    self.btnReset.stopAnimation(animationStyle: .shake, completion: {
                        self.removeLoadingView()
                    })
                    self.showAlertMessage(message: "The email is not existed, please try again")
                }
            })
        })
    }
    
    @objc func successforgot()
    {
        let alert = UIAlertController(title: APP_NAME,
                                      message: "The password has been reset please check your email.",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction.init(title: "OK", style: .cancel) { (success) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
