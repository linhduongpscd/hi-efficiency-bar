//
//  ViewDetailVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/21/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class ViewDetailVC: UIViewController,ASFSharedViewTransitionDataSource {

    @IBOutlet weak var tblDetail: UITableView!
     @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var btnAddMyCard: TransitionButton!
    @IBOutlet weak var lblQuanlity: UILabel!
    var number = 1
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tblDetail.register(UINib(nibName: "CurrentOrderCellNotTimeLine", bundle: nil), forCellReuseIdentifier: "CurrentOrderCell")
        btnAddMyCard.spinnerColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        //self.navigationController?.view.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doTang(_ sender: Any) {
        number = number + 1
        lblQuanlity.text = "\(number)"
        CommonHellper.animateButton(view: lblQuanlity)
    }
    
    @IBAction func doGiam(_ sender: Any) {
        if number == 1
        {
            
        }
        else{
            number = number - 1
            lblQuanlity.text = "\(number)"
            CommonHellper.animateButton(view: lblQuanlity)
        }
    }
    @IBAction func doAddMyTab(_ sender: TransitionButton) {
        btnAddMyCard.startAnimation() // 2: Then start the animation when the user tap the button
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(2) // 3: Do your networking task or background work here.
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.btnAddMyCard.setTitle("", for: .normal)
                self.btnAddMyCard.setImage(#imageLiteral(resourceName: "ic_check"), for: .normal)
                // 4: Stop the animation, here you have three options for the `animationStyle` property:
                // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                // .shake: when you want to reflect to the user that the task did not complete successfly
                // .normal
                self.btnAddMyCard.stopAnimation(animationStyle: .shake, completion: {
                })
            })
        })
    }
    
    func sharedView() -> UIView! {
        return imgDetail
    }
}
extension ViewDetailVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblDetail.dequeueReusableCell(withIdentifier: "CurrentOrderCell") as! CurrentOrderCell
       if indexPath.row == 2
       {
            cell.subContent.backgroundColor = UIColor.init(red: 241/255.0, green: 240/255.0, blue: 144/255.0, alpha: 1.0)
       }
       else{
            cell.subContent.backgroundColor = UIColor.white
        }
        return cell
    }
}

