//
//  SearchTagVC.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 30/03/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class SearchTagVC: UIViewController {

    @IBOutlet weak var txfSearch: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txfSearch.becomeFirstResponder()
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
    
    @IBAction func doCancel(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
}
