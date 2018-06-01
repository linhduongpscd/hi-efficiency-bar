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
import LocalAuthentication
class SignInVC: BaseViewController {

    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var btnSignIn: TransitionButton!
    var userID = Int()
    var token = String()
    var birthday = String()
    @IBOutlet weak var btnTouch: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignIn.spinnerColor = .white
        btnTouch.isHidden = true
        self.deviceSupportsTouchId()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doTouchID(_ sender: Any) {
        self.authenticationWithTouchID()
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
                    UserDefaults.standard.setValue(password, forKey: kPassword)
                    UserDefaults.standard.synchronize()
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
                                            UserDefaults.standard.removeObject(forKey: kPassword)
                                            UserDefaults.standard.synchronize()
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

extension SignInVC {
    func deviceSupportsTouchId() {
        if let token =  UserDefaults.standard.value(forKey: kToken) as? String
        {
            print(token)
            if TouchHelper.supportFaceID() && TouchHelper.isFaceIDAvailable()
            {
                btnTouch.isHidden = false
                btnTouch.setTitle("Login with Face ID", for: .normal)
            }
            else if TouchHelper.isTouchIDAvailable()
            {
                btnTouch.isHidden = false
                btnTouch.setTitle("Login with Touch ID", for: .normal)
            }
            else{
                btnTouch.isHidden = true
            }
        }
        else{
            btnTouch.isHidden = true
        }
    }
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    print("success")
                    DispatchQueue.main.async {
                        // Update UI
                        if let token =  UserDefaults.standard.value(forKey: kToken) as? String
                        {
                            UserDefaults.standard.set(token, forKey: kLoginApp)
                            UserDefaults.standard.synchronize()
                        }
                        APP_DELEGATE.initTabbarHome()
                    }
                    
                    //TODO: User authenticated successfully, take appropriate action
                    
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                   // self.showAlertMessage(message: error.localizedDescription)
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            self.showAlertMessage(message: error.localizedDescription)
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}
