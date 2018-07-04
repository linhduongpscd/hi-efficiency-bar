//
//  SignUpVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import Alamofire
class SignUpVC: BaseViewController {
    
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfConfimPassword: UITextField!
    @IBOutlet weak var txfDateTime: UITextField!
    @IBOutlet weak var btnAvatar: UIButton!
    @IBOutlet weak var btnTick: UIButton!
    var isTick = false
    var isSelectAvatar = false
    var pickerView = PickerView.init(frame: .zero)
    var imagePicker: UIImagePickerController!
    var imageAvatar = UIImage.init()
    @IBOutlet weak var btnSignUp: SSSpinnerButton!
    @IBOutlet weak var txfLastName: UITextField!
    var stringBirthday = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignUp.spinnerColor = .white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doDateTime(_ sender: Any) {
        self.view.endEditing(true)
        pickerView = Bundle.main.loadNibNamed("PickerView", owner: self, options: nil)?[0] as! PickerView
        pickerView.delegate = self
        pickerView.frame = UIScreen.main.bounds
        APP_DELEGATE.window?.addSubview(pickerView)
        AnimationManager.sharedInstance().doAppearView(fromBottom: pickerView)
    }
    
    @IBAction func doAvatar(_ sender: Any) {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let takePhoto = UIAlertAction.init(title: "Take Photo", style: .default) { (action) in
            self .showCamera()
        }
        
        alert.addAction(takePhoto)
        
        let selectPhoto = UIAlertAction.init(title: "Choose Photo", style: .default) { (action) in
            self .showLibrary()
        }
        
        alert.addAction(selectPhoto)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
   
    func showCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func showLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func doTick(_ sender: Any) {
        isTick = !isTick
        if isTick {
            btnTick.setImage(#imageLiteral(resourceName: "ic_terms2"), for: .normal)
        }
        else{
              btnTick.setImage(#imageLiteral(resourceName: "ic_terms1"), for: .normal)
        }
    }
    
    @IBAction func doLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func actionSignUp(_ sender: SSSpinnerButton) {
      
        let name = CommonHellper.trimSpaceString(txtString: txfName.text!)
        let lastName = CommonHellper.trimSpaceString(txtString: txfLastName.text!)
        let email = CommonHellper.trimSpaceString(txtString: txfEmail.text!)
        let password = txfPassword.text!
        let confirmpassword = txfConfimPassword.text!
        let date = txfDateTime.text!
        if name.isEmpty
        {
            self.showAlertMessage(message: ERROR_NAME)
            return
        }
        if lastName.isEmpty
        {
            self.showAlertMessage(message: ERROR_LASTNAME)
            return
        }
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
        
        if confirmpassword.isEmpty {
            self.showAlertMessage(message: ERROR_CONFIRM_PASSWORD)
            return
        }
        
        if  password != confirmpassword {
            self.showAlertMessage(message: ERROR_PASSWORD_NOTMATCH)
            return
        }
        
        if date.isEmpty {
            self.showAlertMessage(message: ERROR_BIRTHDAY)
            return
        }
        
        if !isSelectAvatar {
            self.showAlertMessage(message: ERROR_AVATAR)
            return
        }
        
        if !isTick {
            self.showAlertMessage(message: ERROR_ACCEPT)
            return
        }
        let para = ["first_name":name,"last_name":lastName, "email":email,"password":password,"birthday":stringBirthday]
        self.addLoadingView()
        sender.setBackgroundImage(#imageLiteral(resourceName: "color_tim"), for: .normal)
        sender.startAnimate(spinnerType: .circleStrokeSpin, spinnercolor: .white, complete: nil)
        
        ManagerWS.shared.register(para, self.imageAvatar, complete: { (success, error) in
            if success!
            {
                sender.stopAnimate(complete: {
                     self.removeLoadingView()
                    sender.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
                    self.btnSignUp.setTitle("", for: .normal)
                    self.btnSignUp.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                    self.perform(#selector(self.actionTabbar), with: nil, afterDelay: 0.5)
                })
                
            }
            else{
                sender.stopAnimate(complete: {
                    self.btnSignUp.setTitle("SIGN UP", for: .normal)
                    sender.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
                    self.removeLoadingView()
                    self.showAlertMessage(message: (error?.msg!)!)
                })
                self.showAlertMessage(message: (error?.msg!)!)
            }
        })
        
    }
    
  
    
    @objc func actionTabbar()
    {
        self.navigationController?.popViewController(animated: true)
    }
}
extension SignUpVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfName {
            txfEmail.becomeFirstResponder()
        }
        else if textField == txfEmail {
            txfPassword.becomeFirstResponder()
        }
        else if textField == txfPassword {
            txfConfimPassword.becomeFirstResponder()
        }
        else{
            txfConfimPassword.resignFirstResponder()
        }
        return true
    }
}

extension SignUpVC: PickerViewDelegate
{
    func tapCancelPicker() {
        AnimationManager.sharedInstance().doDisappearView(toBottom: pickerView)
    }
    
    func tapDonePicker(value: Date) {
        stringBirthday = CommonHellper.formatDateBirthday(date: value)
        txfDateTime.text = CommonHellper.formatDateBirthday2(date: value)
        AnimationManager.sharedInstance().doDisappearView(toBottom: pickerView)
    }
}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                let controller = CropViewController()
                controller.delegate = self
                controller.image = image
                
                let navController = UINavigationController(rootViewController: controller)
                self.present(navController, animated: true, completion: nil)
                
            }
        }
        
        
    }
}

extension SignUpVC: CropViewControllerDelegate
{
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage)
    {
        controller.dismiss(animated: true, completion: nil)
        isSelectAvatar = true
        imageAvatar = image
        self.btnAvatar.setImage(image, for: .normal)
        self.btnAvatar.layer.cornerRadius = self.btnAvatar.frame.size.width/2
        self.btnAvatar.layer.masksToBounds = true
    }
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect)
    {
          controller.dismiss(animated: true, completion: nil)
    }
    func cropViewControllerDidCancel(_ controller: CropViewController)
    {
         controller.dismiss(animated: true, completion: nil)
    }
}
