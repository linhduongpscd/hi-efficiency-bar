//
//  SignInVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
class SignInVC: UIViewController {

    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var btnSignIn: TransitionButton!
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
        btnSignIn.startAnimation() // 2: Then start the animation when the user tap the button
       
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
           
            sleep(2) // 3: Do your networking task or background work here.
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.btnSignIn.setTitle("", for: .normal)
                self.btnSignIn.setImage(#imageLiteral(resourceName: "ic_check"), for: .normal)
                // 4: Stop the animation, here you have three options for the `animationStyle` property:
                // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                // .shake: when you want to reflect to the user that the task did not complete successfly
                // .normal
                self.btnSignIn.stopAnimation(animationStyle: .shake, completion: {
                   
                    
                })
                 self.perform(#selector(self.clickAgeVertified), with: nil, afterDelay: 2.0)
            })
        })
    }
    
    @objc func clickAgeVertified()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AgeVerificationVC") as! AgeVerificationVC
        self.navigationController?.pushViewController(vc, animated: true)
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
