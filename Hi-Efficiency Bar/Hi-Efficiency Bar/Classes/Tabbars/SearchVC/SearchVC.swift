//
//  SearchVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var txfSearch: UITextField!
    @IBOutlet weak var tagViews: TagsView!
    var stringTag = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search"
        tagViews.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIColor.lightGray.as1ptImage()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doSearchGenere(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "SearchGenereVC") as! SearchGenereVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doSearchIngredient(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "IngredientVC") as! IngredientVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchVC: TagsDelegate{
    
    // Tag Touch Action
    func tagsTouchAction(_ tagsView: TagsView, tagButton: TagButton) {
        CommonHellper.animateViewSmall(view: tagButton)
        stringTag = self.tagViews.tagTextArray[tagButton.index]
         self.perform(#selector(self.viewDetail), with: nil, afterDelay: 0.8)
    }
    
    @objc func viewDetail()
    {
        let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "DetailTagVC") as! DetailTagVC
        vc.stringTag = stringTag
        self.navigationController?.pushViewController(vc, animated: true)

    }
    // Last Tag Touch Action
    func tagsLastTagAction(_ tagsView: TagsView, tagButton: TagButton) {
        
    }
    
    // TagsView Change Height
    func tagsChangeHeight(_ tagsView: TagsView, height: CGFloat) {
        
    }
}
extension SearchVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txfSearch.resignFirstResponder()
        return true
    }
}
