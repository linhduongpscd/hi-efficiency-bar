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
    @IBOutlet weak var btnSignIn: SSSpinnerButton!
    var userID = Int()
    var token = String()
    var birthday = String()
    @IBOutlet weak var btnTouch: UIButton!
    @IBOutlet weak var imgTouch: UIImageView!
    @IBOutlet weak var lblTouch: UILabel!
    @IBOutlet weak var traingPasword: NSLayoutConstraint!
    var timer: Timer?
    var indexSecond = 0.0   
    var isSuccess = false
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignIn.spinnerColor = .white
        btnTouch.isHidden = true
        imgTouch.isHidden = true
        lblTouch.isHidden = true
        self.deviceSupportsTouchId()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doTouchID(_ sender: Any) {
        //UIControl().sendAction(#selector(NSXPCConnection.suspend),
                              // to: UIApplication.shared, for: nil)
        self.authenticationWithTouchID()
    }
    
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
                if isSuccessPai!
                {
                    
                    self.btnSignIn.stopAnimate(complete: {
                        self.removeLoadingView()
                        self.btnSignIn.alpha = 0.1
                        UIView.animate(withDuration: 0.5, animations: {
                            self.btnSignIn.alpha = 1.0
                            self.userID = self.idApi!
                            self.token = self.tokenApi!
                            self.birthday = self.birthdayApi!
                            self.removeLoadingView()
                            self.btnSignIn.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
                            self.btnSignIn.setTitle("", for: .normal)
                            self.btnSignIn.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                            
                            UserDefaults.standard.setValue(self.txfPassword.text!, forKey: kPassword)
                            UserDefaults.standard.synchronize()
                        }, completion: { (success) in
                            
                            self.perform(#selector(self.clickAgeVertified), with: nil, afterDelay: 0.5)
                        })
                    })
                    
                }
                else{
                    timer?.invalidate()
                    timer = nil
                    btnSignIn.stopAnimate(complete: {
                        self.btnSignIn.setTitle("SIGN IN", for: .normal)
                        self.btnSignIn.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
                        self.removeLoadingView()
                        self.showAlertMessage(message: (self.errorApi?.msg!)!)
                    })
                    
                    
                }
            }
            else{
                indexSecond =  0.1
            }
        }
    }
    
    var isSuccessPai: Bool?
    var errorApi: ErrorModel?
    var tokenApi: String?
    var idApi: Int?
    var birthdayApi: String?
    @IBAction func doSignIn(_ sender: SSSpinnerButton) {
       
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
        self.view.endEditing(true)
        let para = ["email":email,"password":password]
        self.addLoadingView()
        sender.setBackgroundImage(#imageLiteral(resourceName: "color_tim"), for: .normal)
        sender.startAnimate(spinnerType: .circleStrokeSpin, spinnercolor: .white, complete: nil)
        indexSecond = 0.1
          self.isSuccess = false
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timeSecond), userInfo: nil, repeats: true)
        sender.startAnimate(spinnerType: .circleStrokeSpin, spinnercolor: .white) {
        }
        ManagerWS.shared.loginUser(para, complete: { (success, error, token,id,birthday)  in
            self.isSuccess = true
            self.isSuccessPai = success
            self.errorApi = error
            self.tokenApi = token
            self.idApi = id
            self.birthdayApi = birthday
            
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
        fbLoginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if (error == nil){
               
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        if((FBSDKAccessToken.current()) != nil){
                            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in

                                if (error == nil){
                                    CommonHellper.showBusy()
                                    let para: Parameters = ["fb_token": fbloginresult.token.tokenString]
                                    print(para)
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
                imgTouch.isHidden = false
                lblTouch.isHidden = false
                btnTouch.setTitle("", for: .normal)
                lblTouch.text = "Face ID"
                imgTouch.image = #imageLiteral(resourceName: "faceid")
                traingPasword.constant = 60
            }
            else if TouchHelper.isTouchIDAvailable()
            {
                btnTouch.isHidden = false
                imgTouch.isHidden = false
                lblTouch.isHidden = false
                  lblTouch.text = "Touch ID"
                imgTouch.image = #imageLiteral(resourceName: "touchid")
                traingPasword.constant = 60
            }
            else{
                btnTouch.isHidden = true
                imgTouch.isHidden = true
                lblTouch.isHidden = true
                traingPasword.constant = 10
            }
        }
        else{
            btnTouch.isHidden = true
            imgTouch.isHidden = true
            lblTouch.isHidden = true
             traingPasword.constant = 10
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
