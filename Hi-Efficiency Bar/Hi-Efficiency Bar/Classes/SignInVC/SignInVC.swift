//
//  SignInVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
class SignInVC: BaseViewController {

    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var btnSignIn: TransitionButton!
    var userID = Int()
    var token = String()
    var birthday = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignIn.spinnerColor = .white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doSignIn(_ sender: TransitionButton) {
       
        let email = CommonHellper.trimSpaceString(txtString: txfUsername.text!)
        let password = txfPassword.text!
      
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
        
        if password.isEmpty
        {
            self.showAlertMessage(message: ERROR_PASSWORD)
            return
        }
        let para = ["email":email,"password":password]
        self.addLoadingView()
        btnSignIn.startAnimation() // 2: Then start the animation when the user tap the button
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            ManagerWS.shared.loginUser(para, complete: { (success, error, token,id,birthday)  in
                if success!
                {
                    self.userID = id!
                    self.token = token!
                    self.birthday = birthday!
                    self.removeLoadingView()
                    self.btnSignIn.setTitle("", for: .normal)
                    self.btnSignIn.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                    self.btnSignIn.stopAnimation(animationStyle: .shake, completion: {
                        
                        
                    })
                    self.perform(#selector(self.clickAgeVertified), with: nil, afterDelay: 0.5)
                }
                else{
                    self.btnSignIn.setTitle("SIGN IN", for: .normal)
                    self.btnSignIn.stopAnimation(animationStyle: .shake, completion: {
                        self.removeLoadingView()
                         self.showAlertMessage(message: (error?.msg!)!)
                    })
                   
                }
            })
        })
    }
    
    @objc func clickAgeVertified()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AgeVerificationVC") as! AgeVerificationVC
        vc.userID = self.userID
        vc.token = self.token
        vc.birthday = self.birthday
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doFacebook(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        if((FBSDKAccessToken.current()) != nil){
                            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                if (error == nil){
                                    CommonHellper.showBusy()
                                    let para: Parameters = ["fb_token": fbloginresult.token.tokenString]
                                    ManagerWS.shared.loginFacebook(para: para, complete: { (success, error) in
                                        CommonHellper.hideBusy()
                                        if success!
                                        {
                                            APP_DELEGATE.initTabbarHome()
                                        }
                                        else{
                                            self.showAlertMessage(message: (error?.msg)!)
                                        }
                                    })
                                }
                            })
                        }
                    }
                }
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

extension SignInVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfUsername {
            txfPassword.becomeFirstResponder()
        }
        else{
            txfPassword.resignFirstResponder()
        }
        return true
    }
}
