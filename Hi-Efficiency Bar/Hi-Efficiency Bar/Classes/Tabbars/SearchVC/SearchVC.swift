//
//  SearchVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class SearchVC: BaseViewController, ASFSharedViewTransitionDataSource {
    //var arrNames = ["Basics", "Spirits","Liquers","Mixers","Other","Fruits"]
    @IBOutlet weak var collectionView: UICollectionView!
    var stringTag = ""
    var isQuickSearch = true
    var isSearchIngre = false
    var isSearchGenre = false
    var arrGeneres = [GenreObj]()
    var arrBasics = [IngredientSearchObj]()
    var arrSpirits = [IngredientSearchObj]()
    var arrLiquers = [IngredientSearchObj]()
    var arrMixers = [IngredientSearchObj]()
    var arrOther = [IngredientSearchObj]()
    var arrFruits = [IngredientSearchObj]()
    var isLoadMoreFruits = false
    var isLoadMoreBasics = false
    var isLoadMoreSpirits = false
    var isLoadMoreLiquers = false
    var isLoadMoreMixers = false
    var isLoadMoreOher = false
    
    var offsetFruits = 0
    var offsetBasics = 0
    var offsetSpirits = 0
    var offsetLiquers = 0
    var offsetMixers = 0
    var offsetOher = 0
    var indexMenu = 0
    @IBOutlet weak var viewDrink: UIView!
    @IBOutlet weak var imgDrink: UIImageView!
    var arrDrinkCreate = [DrinkObj]()
    var listDrinkCreateView = ListDrinkCreateView.init(frame: .zero)
    var arrIngredientSearch = [IngredientSearchObj]()
    var arrIngredientSelectedSearch = [Int]()
    @IBOutlet weak var subSearchTag: UIView!
    @IBOutlet weak var collectionSearch: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initController()
        self.fectGenereSearch()
        self.fetchCallWSByTypeSearch(index: 0)
        self.fetchCallWSByTypeSearch(index: 1)
        self.fetchCallWSByTypeSearch(index: 2)
        self.fetchCallWSByTypeSearch(index: 3)
        self.fetchCallWSByTypeSearch(index: 4)
        self.fetchCallWSByTypeSearch(index: 5)
        viewDrink.isHidden = true
        subSearchTag.isHidden = true
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.viewDrink.addGestureRecognizer(gestureRecognizer)
         ASFSharedViewTransition.addWith(fromViewControllerClass: SearchVC.self, toViewControllerClass: ViewDetailVC.self, with: self.navigationController, withDuration: 0.3)
    }
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    func initController()
    {
        self.navigationItem.title = "Search"
        self.collectionView.register(UINib(nibName: "QuickSearchCollect", bundle: nil), forCellWithReuseIdentifier: "QuickSearchCollect")
        self.collectionView.register(UINib(nibName: "HeaderSearchReusable", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderSearchReusable")
        self.collectionView.register(UINib(nibName: "IngreItemCollect", bundle: nil), forCellWithReuseIdentifier: "IngreItemCollect")
        self.collectionView.register(UINib(nibName: "MenuSearchCollect", bundle: nil), forCellWithReuseIdentifier: "MenuSearchCollect")
        self.collectionView.register(UINib(nibName: "SearchGenereCollect", bundle: nil), forCellWithReuseIdentifier: "SearchGenereCollect")
           self.collectionView.register(UINib(nibName: "FooterDetailTag", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterDetailTag")
        self.collectionSearch.register(UINib(nibName: "IngreItemCollect", bundle: nil), forCellWithReuseIdentifier: "IngreItemCollect")
        self.configHideNaviScroll(collectionView)
    }
    
    func fectGenereSearch()
    {
        ManagerWS.shared.getSearchGenere { (success, arrs) in
            self.arrGeneres = arrs!
            self.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func sharedView() -> UIView! {
        listDrinkCreateView.createDrinkCollect.imgCell.isHidden = true
        return listDrinkCreateView.createDrinkCollect.imgCell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func fetchCallWSByTypeSearch(index: Int)
    {
        var valueBy = 0
        var offset = 0
        switch index {
        case 0:
            valueBy = CONST_SEARCH_BASICS
            offset = offsetBasics
        case 1:
            valueBy = CONST_SEARCH_SPIRITS
             offset = offsetSpirits
        case 2:
            valueBy = CONST_SEARCH_LIQUERS
             offset = offsetLiquers
        case 3:
            valueBy = CONST_SEARCH_MIXERS
             offset = offsetMixers
        case 4:
            valueBy = CONST_SEARCH_OTHER
             offset = offsetOher
        case 5:
            valueBy = CONST_SEARCH_FRUITS
             offset = offsetFruits
        default:
            valueBy = 0
        }
        ManagerWS.shared.fetchListSearchIngredient(id: valueBy, offset: offset) { (success, arrs) in
            switch index {
            case 0:
                if (arrs?.count)! >= kLimitPage
                {
                    self.isLoadMoreBasics = true
                }
                else{
                    self.isLoadMoreBasics = false
                }
                for obj in arrs!
                {
                    self.arrBasics.append(obj)
                }
                self.collectionView.reloadData()
            case 1:
                if (arrs?.count)! >= kLimitPage
                {
                    self.isLoadMoreSpirits = true
                }
                else{
                    self.isLoadMoreSpirits = false
                }
                for obj in arrs!
                {
                    self.arrSpirits.append(obj)
                }
                self.collectionView.reloadData()
            case 2:
                if (arrs?.count)! >= kLimitPage
                {
                    self.isLoadMoreLiquers = true
                }
                else{
                    self.isLoadMoreLiquers = false
                }
                for obj in arrs!
                {
                    self.arrLiquers.append(obj)
                }
                self.collectionView.reloadData()
            case 3:
                if (arrs?.count)! >= kLimitPage
                {
                    self.isLoadMoreMixers = true
                }
                else{
                    self.isLoadMoreMixers = false
                }
                for obj in arrs!
                {
                    self.arrMixers.append(obj)
                }
                self.collectionView.reloadData()
            case 4:
                if (arrs?.count)! >= kLimitPage
                {
                    self.isLoadMoreOher = true
                }
                else{
                    self.isLoadMoreOher = false
                }
                for obj in arrs!
                {
                    self.arrOther.append(obj)
                }
                self.collectionView.reloadData()
            case 5:
                if (arrs?.count)! >= kLimitPage
                {
                    self.isLoadMoreFruits = true
                }
                else{
                    self.isLoadMoreFruits = false
                }
                for obj in arrs!
                {
                    self.arrFruits.append(obj)
                }
                self.collectionView.reloadData()
            default:
                valueBy = 0
            }
        }
    }
  
    func returnNumberRow()->Int
    {
        switch indexMenu {
        case 0:
            return arrBasics.count + 1
        case 1:
            return arrSpirits.count + 1
        case 2:
            return arrLiquers.count + 1
        case 3:
            return arrMixers.count + 1
        case 4:
            return arrOther.count + 1
        case 5:
            return arrFruits.count + 1
        default:
            return 0
        }
    }
    
    func arrayDatas()->[IngredientSearchObj]
    {
        switch indexMenu {
        case 0:
            return arrBasics
        case 1:
            return arrSpirits
        case 2:
            return arrLiquers
        case 3:
            return arrMixers
        case 4:
            return arrOther
        case 5:
            return arrFruits
        default:
            return arrBasics
        }
    }
    
    func convertToParamSearchDrinkByUser()->String
    {
        var value = ""
        var arrAlls = [IngredientSearchObj]()
        arrAlls.append(contentsOf: self.arrBasics)
        arrAlls.append(contentsOf: self.arrSpirits)
        arrAlls.append(contentsOf: self.arrLiquers)
        arrAlls.append(contentsOf: self.arrMixers)
        arrAlls.append(contentsOf: self.arrOther)
        arrAlls.append(contentsOf: self.arrFruits)
        for obj in arrAlls
        {
            if obj.isSeleled!
            {
                value = "\(value)\(obj.id!),"
            }
        }
        if value.isEmpty
        {
            return "0"
        }
        else{
            return  value.substring(from: 0, to: value.count - 1)
        }
        
    }
    func numberBagdeByCategory(index: Int) -> Int
    {
        var number = 0
        switch index {
        case 0:
            for obj in arrBasics
            {
                if obj.isSeleled!
                {
                    number = number + 1
                }
            }
            return number
        case 1:
            for obj in arrSpirits
            {
                if obj.isSeleled!
                {
                    number = number + 1
                }
            }
            return number
        case 2:
            for obj in arrLiquers
            {
                if obj.isSeleled!
                {
                    number = number + 1
                }
            }
            return number
        case 3:
            for obj in arrMixers
            {
                if obj.isSeleled!
                {
                    number = number + 1
                }
            }
            return number
        case 4:
            for obj in arrOther
            {
                if obj.isSeleled!
                {
                    number = number + 1
                }
            }
            return number
        case 5:
            for obj in arrFruits
            {
                if obj.isSeleled!
                {
                    number = number + 1
                }
            }
            return number
        default:
            return 0
        }
    }
    @IBAction func doDrink(_ sender: Any) {
        listDrinkCreateView = Bundle.main.loadNibNamed("ListDrinkCreateView", owner: self, options: nil)?[0] as! ListDrinkCreateView
        listDrinkCreateView.frame = UIScreen.main.bounds
        listDrinkCreateView.arrDrinks = self.arrDrinkCreate
        listDrinkCreateView.registerCell()
        listDrinkCreateView.tapCloseList = { [] in
            self.listDrinkCreateView.removeFromSuperview()
        }
        listDrinkCreateView.tapDetailDrink = { [] in
            let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailVC") as! ViewDetailVC
            vc.drinkObj = self.arrDrinkCreate[(self.listDrinkCreateView.indexPathCell?.row)!]
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        view.addSubview(listDrinkCreateView)
        
    }
    
    func makeReadSearch()
    {
        for recod in arrIngredientSearch {
            if recod.isSeleled!
            {
//                if !self.arrIngredientSelectedSearch.contains(recod.id!)
//                {
//                    self.arrIngredientSelectedSearch.append(recod.id!)
//
//                }
                if recod.type_search == CONST_SEARCH_BASICS
                {
                    var arrID = [Int]()
                    for item in self.arrBasics
                    {
                        if item.id == recod.id
                        {
                            item.isSeleled = true
                        }
                        arrID.append(item.id!)
                    }
                    if !arrID.contains(recod.id!)
                    {
                        self.arrBasics.append(recod)
                    }
                    
                }
                else if recod.type_search == CONST_SEARCH_SPIRITS
                {
                    var arrID = [Int]()
                    for item in self.arrSpirits
                    {
                        if item.id == recod.id
                        {
                            item.isSeleled = true
                        }
                        arrID.append(item.id!)
                    }
                    if !arrID.contains(recod.id!)
                    {
                        self.arrSpirits.append(recod)
                    }
                }
                else if recod.type_search == CONST_SEARCH_LIQUERS
                {
                    var arrID = [Int]()
                    for item in self.arrLiquers
                    {
                        if item.id == recod.id
                        {
                            item.isSeleled = true
                        }
                        arrID.append(item.id!)
                    }
                    if !arrID.contains(recod.id!)
                    {
                        self.arrLiquers.append(recod)
                    }
                }
                else if recod.type_search == CONST_SEARCH_MIXERS
                {
                    var arrID = [Int]()
                    for item in self.arrMixers
                    {
                        if item.id == recod.id
                        {
                            item.isSeleled = true
                        }
                        arrID.append(item.id!)
                    }
                    if !arrID.contains(recod.id!)
                    {
                        self.arrMixers.append(recod)
                    }
                }
                else if recod.type_search == CONST_SEARCH_OTHER
                {
                    var arrID = [Int]()
                    for item in self.arrOther
                    {
                        if item.id == recod.id
                        {
                            item.isSeleled = true
                        }
                        arrID.append(item.id!)
                    }
                    if !arrID.contains(recod.id!)
                    {
                        self.arrOther.append(recod)
                    }
                }
                else{
                    var arrID = [Int]()
                    for item in self.arrFruits
                    {
                        if item.id == recod.id
                        {
                            item.isSeleled = true
                        }
                        arrID.append(item.id!)
                    }
                    if !arrID.contains(recod.id!)
                    {
                        self.arrFruits.append(recod)
                    }
                }
                
            }
        }
        collectionView.reloadData()
        CommonHellper.showBusy()
        ManagerWS.shared.createDrinkByUser(self.convertToParamSearchDrinkByUser(), complete: { (success, arrs) in
            CommonHellper.hideBusy()
            self.arrDrinkCreate = arrs!
            if arrs?.count == 0
            {
                self.viewDrink.isHidden = true
            }
            else{
                self.viewDrink.isHidden = false
                let obj = arrs!.last
                if obj?.image != nil
                {
                    self.imgDrink.sd_setImage(with: URL.init(string: (obj?.image!)!), completed: { (image, error, type, url) in
                        
                    })
                }
            }
            
        })
    }
}

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == collectionSearch
        {
            return 1
        }
        else{
             return 3
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionSearch
        {
            return arrIngredientSearch.count
        }
        else{
            if section == 0
            {
                if isQuickSearch
                {
                    return 1
                }
                return 0
            }
            if section == 1 {
                if isSearchIngre
                {
                    
                    return self.returnNumberRow()
                }
                return 0
            }
            if isSearchGenre
            {
                return self.arrGeneres.count
            }
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionSearch
        {
            let cell = collectionSearch.dequeueReusableCell(withReuseIdentifier: "IngreItemCollect", for: indexPath) as! IngreItemCollect
            self.configCell(cell, self.arrIngredientSearch[indexPath.row])
            return cell
        }
        else{
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickSearchCollect", for: indexPath) as! QuickSearchCollect
                cell.taptags = { [weak self] in
                    let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "DetailTagVC") as! DetailTagVC
                    vc.stringTag = cell.stringTag
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                cell.tapSearchQuickly = { [weak self] in
                    let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "SearchTagVC") as! SearchTagVC
//                    vc.tapDetailSearch = { [] in
//                       
//                    }
                    let nav = BaseNaviController.init(rootViewController: vc)
                    self?.present(nav, animated: true, completion: nil)
                }
                return cell
            }
            else if indexPath.section == 1 {
                if indexPath.row == 0
                {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuSearchCollect", for: indexPath) as! MenuSearchCollect
                    cell.registerCell()
                    cell.tapSelectMenu = { [] in
                        self.indexMenu = cell.indexSelect
                        self.collectionView.reloadData()
                    }
                    cell.tapBeginSearch = { [] in
                        self.arrIngredientSearch.removeAll()
                        self.collectionSearch.reloadData()
                        self.collectionSearch.backgroundColor = UIColor.clear
                        self.subSearchTag.isHidden = false
                    }
                    cell.tapDoneSearch = { [] in
                        self.makeReadSearch()
                        self.subSearchTag.isHidden = true
                    }
                    cell.tapReturnSearch = { [] in
                        if !CommonHellper.trimSpaceString(txtString: cell.txfSearch.text!).isEmpty
                        {
                            ManagerWS.shared.SearchIngredient(value: CommonHellper.trimSpaceString(txtString: cell.txfSearch.text!), complete: { (success, arrs) in
                                self.arrIngredientSearch.removeAll()
                                self.arrIngredientSearch = arrs!
                                self.collectionSearch.backgroundColor = UIColor.white
                                self.collectionSearch.reloadData()
                            })
                        }
                       
                    }
                    cell.badgeBasics = self.numberBagdeByCategory(index: 0)
                    cell.badgeSpirits = self.numberBagdeByCategory(index: 1)
                    cell.badgeLiquers = self.numberBagdeByCategory(index: 2)
                    cell.badgeMixers = self.numberBagdeByCategory(index: 3)
                    cell.badgeOther = self.numberBagdeByCategory(index: 4)
                    cell.badgeFruits = self.numberBagdeByCategory(index: 5)
                    cell.collectionView.reloadData()
                    return cell
                }
                else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngreItemCollect", for: indexPath) as! IngreItemCollect
                    self.configCell(cell, self.arrayDatas()[indexPath.row - 1])
                    return cell
                }
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchGenereCollect", for: indexPath) as! SearchGenereCollect
            let obj = arrGeneres[indexPath.row]
            cell.lblName.text = obj.name
            if obj.image != nil
            {
                if let imageurl = URL.init(string: obj.image!)
                {
                    let name = imageurl.lastPathComponent
                    if name.lowercased().contains("gif")
                    {
                        let imageURL = UIImage.gifImageWithURL(obj.image!)
                        cell.imgCell.image = imageURL
                    }
                    else{
                        cell.imgCell.sd_setImage(with: URL.init(string: obj.image!), completed: { (image, error, type, url) in
                            
                        })
                    }
                }
                else{
                    cell.imgCell.sd_setImage(with: URL.init(string: obj.image!), completed: { (image, error, type, url) in
                        
                    })
                }
               
            }
            if indexPath.row % 2 == 0
            {
                cell.leftConstraint.constant = 10.0
                 cell.rightConstraint.constant = 0
            }
            else{
                cell.leftConstraint.constant = 0
                 cell.rightConstraint.constant = 10.0
            }
            return cell
        }
        
        
    }
    
    func configCell(_ cell: IngreItemCollect, _ obj: IngredientSearchObj)
    {
        cell.lbltext.text = obj.name
        cell.lbltext.textColor = UIColor.black
        if obj.isSeleled!
        {
            cell.imgCheck.isHidden = false
            cell.subContent.borderWidth = 4.0
            cell.subContent.borderColor =  UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha:1.0)
        }
        else{
            cell.imgCheck.isHidden = true
            cell.subContent.borderWidth = 1.0
            cell.subContent.borderColor =  UIColor.clear
        }
        cell.subContent.backgroundColor = obj.bgColor!
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == collectionSearch
        {
              return CGSize(width: (collectionView.frame.size.width - 4)/2, height: 50)
        }
        else
        {
            if indexPath.section == 0 {
                return CGSize(width: collectionView.frame.size.width, height: 400)
            }
            if indexPath.section == 1 {
                if indexPath.row == 0
                {
                    return CGSize(width: collectionView.frame.size.width, height: 120)
                }
                return CGSize(width: (collectionView.frame.size.width - 4)/2, height: 50)
            }
            return CGSize(width:( UIScreen.main.bounds.size.width - 10)/2, height:  170)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == collectionSearch
        {
            let cellWidth : CGFloat = (collectionView.frame.size.width - 4)/2
            
            let numberOfCells = floor(self.view.frame.size.width / cellWidth)
            let edgeInsets = (self.view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
            
            return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets)
        }
        else{
            if section == 1
            {
                let cellWidth : CGFloat = (collectionView.frame.size.width - 4)/2
                
                let numberOfCells = floor(self.view.frame.size.width / cellWidth)
                let edgeInsets = (self.view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
                
                return UIEdgeInsetsMake(15, edgeInsets, 0, edgeInsets)
            }
            else{
                
                return UIEdgeInsetsMake(0, 0, 0, 0)
            }
        }
        
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == collectionSearch
    {
         let obj = arrIngredientSearch[indexPath.row]
         obj.isSeleled = !obj.isSeleled!
        self.collectionSearch.reloadData()
     }
    else{
        if indexPath.section == 1 {
            if indexPath.row > 0
            {
                // 72 181 251
                var obj = IngredientSearchObj.init(dict: NSDictionary.init())
                print(indexPath.row)
                switch indexMenu {
                case 0:
                    obj = arrBasics[indexPath.row - 1]
                case 1:
                    obj = arrSpirits[indexPath.row - 1]
                case 2:
                    obj = arrLiquers[indexPath.row - 1]
                case 3:
                    obj = arrMixers[indexPath.row - 1]
                case 4:
                    obj = arrOther[indexPath.row - 1]
                case 5:
                    obj = arrFruits[indexPath.row - 1]
                default:
                    obj = arrBasics[indexPath.row - 1]
                }
                obj.isSeleled = !obj.isSeleled!
                self.collectionView.reloadData()
                //CommonHellper.showBusy()
                ManagerWS.shared.createDrinkByUser(self.convertToParamSearchDrinkByUser(), complete: { (success, arrs) in
                   // CommonHellper.hideBusy()
                    self.arrDrinkCreate = arrs!
                    if arrs?.count == 0
                    {
                        self.viewDrink.isHidden = true
                    }
                    else{
                        self.viewDrink.isHidden = false
                        let obj = arrs!.last
                        if obj?.image != nil
                        {
                            self.imgDrink.sd_setImage(with: URL.init(string: (obj?.image!)!), completed: { (image, error, type, url) in
                                
                            })
                        }
                    }
                    
                })
            }
        }
        if indexPath.section == 2
        {
            let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "DetailCocktailVC") as! DetailCocktailVC
            vc.genereObj = arrGeneres[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
     
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == collectionSearch
        {
            return UICollectionReusableView.init()
        }
        
        
        if kind == UICollectionElementKindSectionHeader
        {
            let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSearchReusable", for: indexPath) as! HeaderSearchReusable
            if indexPath.section == 0 {
                commentView.lblTitle.text = "Quick Search"
            }
            else if indexPath.section == 1
            {
                commentView.lblTitle.text = "Search by ingredient"
            }
            else{
                commentView.lblTitle.text = "Search by Genere"
            }
            commentView.tapSectionSearch = { [weak self] in
                if indexPath.section == 0
                {
                    
                    self?.isQuickSearch = !(self?.isQuickSearch)!
                    self?.isSearchGenre = false
                    self?.isSearchIngre = false
                    self?.subSearchTag.isHidden = true
                    self?.viewDrink.isHidden = true
                    
                }
                else if indexPath.section == 1
                {
                    self?.isQuickSearch = false
                    self?.isSearchGenre = false
                    self?.isSearchIngre = true
                    if self?.arrDrinkCreate.count == 0
                    {
                        self?.viewDrink.isHidden = true
                    }
                    else{
                        self?.viewDrink.isHidden = false
                    }
                }
                else{
                    self?.subSearchTag.isHidden = true
                    self?.isQuickSearch = false
                    self?.isSearchGenre = true
                    self?.isSearchIngre = false
                    self?.viewDrink.isHidden = true
                }
                self?.collectionView.reloadData()
            }
              return commentView
        }
        else{
            let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterDetailTag", for: indexPath) as! FooterDetailTag
            commentView.tapLoadMore = {[] in
                switch self.indexMenu {
                case 0:
                     self.offsetBasics = self.offsetBasics + kLimitPage
                    self.fetchCallWSByTypeSearch(index: self.indexMenu)
                case 1:
                    self.offsetSpirits = self.offsetSpirits + kLimitPage
                    self.fetchCallWSByTypeSearch(index: self.indexMenu)
                case 2:
                    self.offsetLiquers = self.offsetLiquers + kLimitPage
                    self.fetchCallWSByTypeSearch(index: self.indexMenu)
                case 3:
                    self.offsetMixers = self.offsetMixers + kLimitPage
                    self.fetchCallWSByTypeSearch(index: self.indexMenu)
                case 4:
                    self.offsetOher = self.offsetOher + kLimitPage
                    self.fetchCallWSByTypeSearch(index: self.indexMenu)
                case 5:
                    self.offsetFruits = self.offsetFruits + kLimitPage
                    self.fetchCallWSByTypeSearch(index: self.indexMenu)
               
                default:
                    self.offsetBasics = self.offsetBasics + kLimitPage
                    self.fetchCallWSByTypeSearch(index: self.indexMenu)
                }
            }
            return commentView
        }
        
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == collectionSearch
        {
             return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
        }
        if section == 0 {
            if isQuickSearch
            {
                return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
            }
            return CGSize(width: UIScreen.main.bounds.size.width, height: 44)
        }
        return CGSize(width: UIScreen.main.bounds.size.width, height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == collectionSearch
        {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
        }
        if section == 0
        {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
        }
        else if section == 1
        {
            if isSearchIngre
            {
                switch indexMenu {
                case 0:
                    if isLoadMoreBasics
                    {
                        return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
                    }
                    return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
                case 1:
                    if isLoadMoreSpirits
                    {
                        return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
                    }
                    return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
                case 2:
                    if isLoadMoreLiquers
                    {
                        return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
                    }
                    return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
                case 3:
                    if isLoadMoreMixers
                    {
                        return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
                    }
                    return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
                case 4:
                    if isLoadMoreOher
                    {
                        return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
                    }
                    return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
                case 5:
                    if isLoadMoreFruits
                    {
                        return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
                    }
                    return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
                default:
                    return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
                }
            }
            
            return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
            
        }
        else{
            return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
        }
    }
}
/*
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
 */
