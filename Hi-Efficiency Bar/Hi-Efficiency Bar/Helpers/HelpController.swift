//
//  HelpController.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 10/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class HelpController: UIViewController {
    var loadingView = LoadingView.init(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlertMessage(message: String)
    {
        let alert = UIAlertController(title: APP_NAME,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Ok",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func addLoadingView()
    {
        loadingView =  Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)?[0] as! LoadingView
        loadingView.frame = UIScreen.main.bounds
        APP_DELEGATE.window?.addSubview(loadingView)
    }
    
    func removeLoadingView()
    {
        loadingView.removeFromSuperview()
    }
 

}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
