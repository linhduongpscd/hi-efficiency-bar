//
//  SignUpVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfConfimPassword: UITextField!
    @IBOutlet weak var txfDateTime: UITextField!
    @IBOutlet weak var btnAvatar: UIButton!
    @IBOutlet weak var btnTick: UIButton!
    var isTick = Bool()
     var pickerView = PickerView.init(frame: .zero)
      var imagePicker: UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
      
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
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func showLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
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
    @IBAction func doSignUp(_ sender: Any) {
         APP_DELEGATE.initTabbarHome()
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
        txfDateTime.text = CommonHellper.formatDateBirthday(date: value)
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
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            print(image)
            self.btnAvatar.setImage(image, for: .normal)
            self.btnAvatar.layer.cornerRadius = self.btnAvatar.frame.size.width/2
            self.btnAvatar.layer.masksToBounds = true
        }
        self.dismiss(animated: true) {
            
        }
    }
}
