//
//  ManagerWS.swift
//  ATAX
//
//  Created by QTS Coder on 8/16/17.
//  Copyright © 2017 QTS Coder. All rights reserved.
//

import UIKit
import Alamofire

struct ManagerWS {
    static let shared = ManagerWS()
    private let auth_headerLogin: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded"]
    private var manager: Alamofire.SessionManager
    private init() {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "hiefficiencybar.com": .disableEvaluation
        ]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }
    
    func register(_ para: Parameters, _ image: UIImage, complete:@escaping (_ success: Bool?, _ errer: ErrorModel?) ->Void) {
        let name = Date().millisecondsSince1970
        let imgData = UIImageJPEGRepresentation(image, 1.0)!
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "avatar",fileName: "\(name).jpg", mimeType: "image/jpg")
            for (key, value) in para {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
         to:"\(URL_SERVER)api/user/signup/")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    switch(response.result) {
                    case .success(_):
                        if let code = response.response?.statusCode
                        {
                            print(response)
                            print("CODE   \(code)")
                            if let val = response.value as? NSDictionary
                            {
                                if code == SERVER_CODE.CODE_201
                                {
                                    if let id = val["id"] as? Int
                                    {
                                        UserDefaults.standard.set(id, forKey: kID)
                                        if let token = val["token"] as? String
                                        {
                                            UserDefaults.standard.set(token, forKey: kToken)
                                        }
                                        UserDefaults.standard.synchronize()
                                        complete(true,ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "Success"))
                                    }
                                }
                                else if code == SERVER_CODE.CODE_400
                                {
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "User with this email address already exists."))
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "\(val)"))
                                }
                            }
                            
                        }
                        break
                    case .failure(let error):
                        complete(false, ErrorManager.processError(error: error))
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
       
    }
   
    
    func loginUser(_ para: Parameters, complete:@escaping (_ success: Bool?, _ errer: ErrorModel?, _ token: String?,_ id: Int?,_ birthday: String?) ->Void)
    {
        manager.request(URL.init(string: "\(URL_SERVER)api/user/me/")!, method: .post, parameters: para,  encoding: URLEncoding(destination: .methodDependent), headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let val = response.value as? NSDictionary
                        {
                            if code == SERVER_CODE.CODE_200
                            {
                                if let id = val["id"] as? Int
                                {
                                    if let token = val["token"] as? String
                                    {
                                        if let birthday = val["birthday"] as? String
                                        {
                                            complete(true,ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "Success"), token, id, birthday)
                                        }
                                        else{
                                             complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "Wrong birthday."), nil, nil, nil)
                                        }
                                    }
                                }
                            }
                            else if code == SERVER_CODE.CODE_400
                            {
                                complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "Wrong email or password."), nil, nil, nil)
                            }
                            else{
                                complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "\(val)"),nil,nil, nil)
                            }
                        }
                        
                    }
                    break
                case .failure(let error):
                    complete(false, ErrorManager.processError(error: error), nil, nil, nil)
                }
            }
    }
    
    
    func getMainBar(complete:@escaping (_ success: Bool?, _ arrs: [MainBarObj]?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print(token)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/drink/category/?main=true")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                var arrDatas = [MainBarObj]()
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let arrs = response.value as? NSArray
                        {
                            if code == SERVER_CODE.CODE_200
                            {
                                for item in arrs
                                {
                                    let dictItem = item as! NSDictionary
                                    arrDatas.append(MainBarObj.init(dict: dictItem))
                                }
                                complete(true, arrDatas)
                            }
                        }
                    }
                 break
                    
                case .failure(_):
                    break
                }
            }
    }
    
    func getListDrink(offset: Int,complete:@escaping (_ success: Bool?, _ arrs: [DrinkObj]?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print(token)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/drink/?offset=\(offset)&limit=\(kLimitPage)")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                var arrDatas = [DrinkObj]()
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let val = response.value as? NSDictionary
                        {
                            if let arrs = val.object(forKey: "results") as? NSArray
                            {
                                if code == SERVER_CODE.CODE_200
                                {
                                    for item in arrs
                                    {
                                        let dictItem = item as! NSDictionary
                                        arrDatas.append(DrinkObj.init(dict: dictItem))
                                    }
                                    complete(true, arrDatas)
                                }
                                else{
                                     complete(true, arrDatas)
                                }
                            }
                           
                        }
                    }
                    break
                    
                case .failure(_):
                     complete(true, arrDatas)
                    break
                }
        }
    }
    
    func getSearchDrink(txtSearch: String, offset: Int,complete:@escaping (_ success: Bool?, _ arrs: [DrinkObj]?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        let search = txtSearch.replacingOccurrences(of: " ", with: "%20")
        print(token)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/drink/?offset=\(offset)&limit=\(kLimitPage)&search=\(search)")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                var arrDatas = [DrinkObj]()
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let val = response.value as? NSDictionary
                        {
                            if let arrs = val.object(forKey: "results") as? NSArray
                            {
                                if code == SERVER_CODE.CODE_200
                                {
                                    for item in arrs
                                    {
                                        let dictItem = item as! NSDictionary
                                        arrDatas.append(DrinkObj.init(dict: dictItem))
                                    }
                                    complete(true, arrDatas)
                                }
                                else{
                                     complete(true, arrDatas)
                                }
                            }
                            
                        }
                    }
                    break
                    
                case .failure(_):
                     complete(true, arrDatas)
                    break
                }
        }
    }
    
    func getSearchIngredient(txtSearch: String, offset: Int,complete:@escaping (_ success: Bool?, _ arrs: [Ingredient]?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        var search = txtSearch.replacingOccurrences(of: "#", with: "").lowercased()
        search = search.replacingOccurrences(of: " ", with: "%20")
        print(search)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/ingredient/?offset=\(offset)&limit=\(kLimitPage)&search=\(search)")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                var arrDatas = [Ingredient]()
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let val = response.value as? NSDictionary
                        {
                            if let arrs = val.object(forKey: "results") as? NSArray
                            {
                                if code == SERVER_CODE.CODE_200
                                {
                                    for item in arrs
                                    {
                                        let dictItem = item as! NSDictionary
                                        arrDatas.append(Ingredient.init(dict: dictItem))
                                    }
                                    complete(true, arrDatas)
                                }
                                else{
                                     complete(true, arrDatas)
                                }
                            }
                            
                        }
                    }
                    break
                     complete(true, arrDatas)
                case .failure(_):
                    break
                }
        }
    }
    
    
    func getListDrinkByCategory(categoryID: Int, offset: Int,complete:@escaping (_ success: Bool?, _ arrs: [DrinkObj]?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print(token)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/drink/?category=\(categoryID)&offset=\(offset)&limit=\(kLimitPage)")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                var arrDatas = [DrinkObj]()
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let val = response.value as? NSDictionary
                        {
                            if let arrs = val.object(forKey: "results") as? NSArray
                            {
                                if code == SERVER_CODE.CODE_200
                                {
                                    for item in arrs
                                    {
                                        let dictItem = item as! NSDictionary
                                        arrDatas.append(DrinkObj.init(dict: dictItem))
                                    }
                                    complete(true, arrDatas)
                                }
                                else{
                                     complete(true, arrDatas)
                                }
                            }
                            else{
                                 complete(true, arrDatas)
                            }
                        }
                        else{
                             complete(true, arrDatas)
                        }
                    }
                    break
                    
                case .failure(_):
                     complete(true, arrDatas)
                    break
                }
        }
    }
    
    
    func favUnFavDrink(drinkID: Int,complete:@escaping (_ success: Bool?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print(token)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/user/favorite/\(drinkID)/")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let val = response.value as? NSDictionary
                        {
                            if let arrs = val.object(forKey: "results") as? NSArray
                            {
                                if code == SERVER_CODE.CODE_200
                                {
                                   complete(true)
                                    
                                }
                            }
                            
                        }
                    }
                    break
                    
                case .failure(_):
                    break
                }
        }
    }
    
    func forgotPassword(para: Parameters,complete:@escaping (_ success: Bool?) ->Void)
    {
       
        manager.request(URL.init(string: "\(URL_SERVER)api/user/forget/password/")!, method: .post, parameters: para,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let val = response.value as? NSDictionary
                        {
                            print(val)
                            if code == SERVER_CODE.CODE_200
                            {
                                complete(true)
                                
                            }
                            else{
                                complete(false)
                            }
                            
                        }
                    }
                    break
                    
                case .failure(_):
                    complete(false)
                    break
                }
        }
    }
    
    func getProfile(complete:@escaping (_ success: Bool?, _ inforUser: NSDictionary) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print(token)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/user/me/")!, method: .post, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let val = response.value as? NSDictionary
                        {
                            if code == SERVER_CODE.CODE_200
                            {
                                complete(true, val)
                                
                            }
                            else{
                                complete(false, NSDictionary.init())
                            }
                            
                        }
                    }
                    break
                    
                case .failure(_):
                    complete(false, NSDictionary.init())
                    break
                }
        }
    }
    
    func addMyTab(para: Parameters, complete:@escaping (_ success: Bool?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print(para)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/user/add/tab/")!, method: .post, parameters: para,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        print("CODE --\(code)")
                        if code == SERVER_CODE.CODE_201 || code == SERVER_CODE.CODE_200
                        {
                            complete(true)
                            
                        }
                        else{
                            complete(true)
                        }
                    }
                    break
                    
                case .failure(_):
                    complete(true)
                    break
                }
        }
    }
    
    func getListAllGlass(complete:@escaping (_ success: Bool?, _ arrs: [GlassObj]?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print(token)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/glass/")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                var arrDatas = [GlassObj]()
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let arrs = response.value as? NSArray
                        {
                            if code == SERVER_CODE.CODE_200
                            {
                                for item in arrs
                                {
                                    let dictItem = item as! NSDictionary
                                    arrDatas.append(GlassObj.init(dict: dictItem))
                                }
                                complete(true, arrDatas)
                            }
                            else{
                                 complete(true, arrDatas)
                            }
                            
                        }
                    }
                    break
                    
                case .failure(_):
                     complete(true, arrDatas)
                    break
                }
        }
    }
    
    
    func addDrinkStep1(para: Parameters, complete:@escaping (_ success: Bool?, _ errer: ErrorModel?,_ drinkID: Int?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print(para)
        
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/drink/")!, method: .post, parameters: para,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        print("CODE --\(code)")
                        if code == SERVER_CODE.CODE_201
                        {
                            if let val = response.value as? NSDictionary
                            {
                                if let id = val["id"] as? Int
                                {
                                    complete(true, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "Success"), id)
                                }
                            }
                            else{
                                 complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: response.description), 0)
                            }
                            
                            
                        }
                        else{
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: response.description), 0)
                        }
                    }
                    break
                    
                case .failure(_):
                    //complete(true, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "Success"))
                     complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: response.description), 0)
                    break
                }
        }
    }
    func loginFacebook(para: Parameters, complete:@escaping (_ success: Bool?, _ errer: ErrorModel?) ->Void)
    {
    
        print(para)
        manager.request(URL.init(string: "\(URL_SERVER)api/user/signup/")!, method: .post, parameters: para,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        print(response)
                        print("CODE   \(code)")
                        if let val = response.value as? NSDictionary
                        {
                            if code == SERVER_CODE.CODE_201
                            {
                                if let id = val["id"] as? Int
                                {
                                    UserDefaults.standard.set(id, forKey: kID)
                                    if let token = val["token"] as? String
                                    {
                                        UserDefaults.standard.set(token, forKey: kToken)
                                        UserDefaults.standard.synchronize()
                                        complete(true,ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "Success"))
                                    }
                                    else{
                                          complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "Token invalid."))
                                    }
                                    
                                }
                                else{
                                      complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "Id invalid."))
                                }
                            }
                            else if code == SERVER_CODE.CODE_400
                            {
                                complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "User with this email address already exists."))
                            }
                            else{
                                complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "\(val)"))
                            }
                        }
                        
                    }
                    
                case .failure(_):
                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "User with this email address already exists."))
                    break
                }
        }
    }
    
    // SEARHC CATEGORY
    func getSearchDrinkByCategory(txtSearch: String, offset: Int,complete:@escaping (_ success: Bool?, _ arrs: [GenreObj]?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        var search = txtSearch.replacingOccurrences(of: "#", with: "").lowercased()
         search = search.replacingOccurrences(of: " ", with: "%20")
        //search = "mood"
        print(token)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/drink/category/?offset=\(offset)&limit=\(kLimitPage)&search=\(search)")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                var arrDatas = [GenreObj]()
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let arrs = response.value as? NSArray
                        {
                            if code == SERVER_CODE.CODE_200
                            {
                                for item in arrs
                                {
                                    let dictItem = item as! NSDictionary
                                    arrDatas.append(GenreObj.init(dict: dictItem))
                                }
                                complete(true, arrDatas)
                            }
                            else{
                                 complete(true, arrDatas)
                            }
                            
                        }
                    }
                    break
                    
                case .failure(_):
                     complete(true, arrDatas)
                    break
                }
        }
    }
    
    
    // SEARCH ingredient
    
    func getListDrinkByingredient(ingredientID: Int, offset: Int,complete:@escaping (_ success: Bool?, _ arrs: [DrinkObj]?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print("\(URL_SERVER)api/drink/?ingredient=\(ingredientID)&offset=\(offset)&limit=\(kLimitPage)")
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/drink/?ingredient=\(ingredientID)&offset=\(offset)&limit=\(kLimitPage)")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                var arrDatas = [DrinkObj]()
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let val = response.value as? NSDictionary
                        {
                            if let arrs = val.object(forKey: "results") as? NSArray
                            {
                                if code == SERVER_CODE.CODE_200
                                {
                                    for item in arrs
                                    {
                                        let dictItem = item as! NSDictionary
                                        arrDatas.append(DrinkObj.init(dict: dictItem))
                                    }
                                    complete(true, arrDatas)
                                }
                                else{
                                    complete(true, arrDatas)
                                }
                            }
                            else{
                                complete(true, arrDatas)
                            }
                        }
                        else{
                            complete(true, arrDatas)
                        }
                    }
                    break
                    
                case .failure(_):
                    complete(true, arrDatas)
                    break
                }
        }
    }
    
    // GET LIST FAV
    func getListFavDrinks(offset: Int,complete:@escaping (_ success: Bool?, _ arrs: [DrinkObj]?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print(token)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/drink/?myfavorite=true&offset=\(offset)&limit=\(kLimitPage)")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                var arrDatas = [DrinkObj]()
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let val = response.value as? NSDictionary
                        {
                            if let arrs = val.object(forKey: "results") as? NSArray
                            {
                                if code == SERVER_CODE.CODE_200
                                {
                                    for item in arrs
                                    {
                                        let dictItem = item as! NSDictionary
                                        arrDatas.append(DrinkObj.init(dict: dictItem))
                                    }
                                    complete(true, arrDatas)
                                }
                                else{
                                    complete(true, arrDatas)
                                }
                            }
                            
                        }
                    }
                    break
                    
                case .failure(_):
                    complete(true, arrDatas)
                    break
                }
        }
    }
    
    func getSearchGenere(complete:@escaping (_ success: Bool?, _ arrs: [GenreObj]?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print(token)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/drink/category/?ancestor=true")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                var arrDatas = [GenreObj]()
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let arrs = response.value as? NSArray
                        {
                            if code == SERVER_CODE.CODE_200
                            {
                                for item in arrs
                                {
                                    let dictItem = item as! NSDictionary
                                    arrDatas.append(GenreObj.init(dict: dictItem))
                                }
                                complete(true, arrDatas)
                            }
                            else{
                                complete(true, arrDatas)
                            }
                        }
                    }
                    break
                    
                case .failure(_):
                    complete(true, arrDatas)
                    break
                }
        }
    }
    
    // GET SUB CATEGORY BY PARENT ID
    func getSubCategoryByParentID(parentID: Int, complete:@escaping (_ success: Bool?, _ arrs: [GenreObj]?) ->Void)
    {
        
        CommonHellper.showBusy()
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print(token)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/drink/category/?parent=\(parentID)")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                
                CommonHellper.hideBusy()
                var arrDatas = [GenreObj]()
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let arrs = response.value as? NSArray
                        {
                            if code == SERVER_CODE.CODE_200
                            {
                                for item in arrs
                                {
                                    let dictItem = item as! NSDictionary
                                    arrDatas.append(GenreObj.init(dict: dictItem))
                                }
                                complete(true, arrDatas)
                            }
                            else{
                                complete(true, arrDatas)
                            }
                        }
                    }
                    break
                    
                case .failure(_):
                    complete(true, arrDatas)
                    break
                }
        }
    }
    // GET LIST MY TAB
    func getListMyTab(complete:@escaping (_ success: Bool?, _ arrs: [MyTabObj]?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print(token)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/user/me/tab/")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                var arrDatas = [MyTabObj]()
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let val = response.value as? NSDictionary
                        {
                            if let arrs = val.object(forKey: "results") as? NSArray
                            {
                                if code == SERVER_CODE.CODE_200
                                {
                                    for item in arrs
                                    {
                                        let dictItem = item as! NSDictionary
                                        arrDatas.append(MyTabObj.init(dict: dictItem))
                                    }
                                    complete(true, arrDatas)
                                }
                                else{
                                    complete(true, arrDatas)
                                }
                            }
                            
                        }
                    }
                    break
                    
                case .failure(_):
                    complete(true, arrDatas)
                    break
                }
        }
    }
    
    func deleteMyTab(tabID: Int,complete:@escaping (_ success: Bool?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print("\(URL_SERVER)api/user/me/tab/\(tabID)")
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/user/me/tab/\(tabID)/")!, method: .delete, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if code == SERVER_CODE.CODE_200
                        {
                            complete(true)
                        }
                        else{
                            complete(false)
                        }
                    }
                    break
                    
                case .failure(_):
                    complete(false)
                    break
                }
        }
    }
    
    func updateMyTab(tabID: Int, quantity: Int,complete:@escaping (_ success: Bool?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        let param = ["quantity":quantity]
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/user/me/tab/\(tabID)/")!, method: .patch, parameters: param,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if code == SERVER_CODE.CODE_200
                        {
                            complete(true)
                        }
                        else{
                            complete(false)
                        }
                    }
                    break
                    
                case .failure(_):
                    complete(false)
                    break
                }
        }
    }
    
    func addMyTabCard(token: String,complete:@escaping (_ success: Bool?, _ errer: ErrorModel?) ->Void)
    {
        guard let tokenLogin = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        let param = ["stripe_token":token]
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(tokenLogin)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/user/order/")!, method: .post, parameters: param,  encoding: URLEncoding.methodDependent, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                         print(code)
                        if code == SERVER_CODE.CODE_200 || code == SERVER_CODE.CODE_201
                        {
                            complete(true,ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "Success"))
                        }
                        else{
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "\(response.result.value as? NSDictionary)"))
                        }
                    }
                    break
                    
                case .failure(_):
                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: "\(response.result as? NSDictionary)"))
                    break
                }
        }
    }
    
    func fetchListSearchIngredient(id: Int, offset: Int,complete:@escaping (_ success: Bool?, _ arrs: [IngredientSearchObj]?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print(token)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/drink/?ingredient_by=\(id)&offset=\(offset)&limit=\(kLimitPage)")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                var arrDatas = [IngredientSearchObj]()
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let val = response.value as? NSDictionary
                        {
                            if let arrs = val.object(forKey: "results") as? NSArray
                            {
                                if code == SERVER_CODE.CODE_200
                                {
                                    for item in arrs
                                    {
                                        let dictItem = item as! NSDictionary
                                        arrDatas.append(IngredientSearchObj.init(dict: dictItem))
                                    }
                                    complete(true, arrDatas)
                                }
                                else{
                                    complete(true, arrDatas)
                                }
                            }
                            
                        }
                    }
                    break
                    
                case .failure(_):
                    complete(true, arrDatas)
                    break
                }
        }
    }
    
    func fetchIngredientType(complete:@escaping (_ success: Bool?, _ arrs: [MainBarObj]?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print(token)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/ingredient/type/")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                var arrDatas = [MainBarObj]()
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let arrs = response.value as? NSArray
                        {
                            if code == SERVER_CODE.CODE_200
                            {
                                for item in arrs
                                {
                                    let dictItem = item as! NSDictionary
                                    arrDatas.append(MainBarObj.init(dict: dictItem))
                                }
                                complete(true, arrDatas)
                            }
                            else{
                                complete(true, arrDatas)
                            }
                        }
                    }
                    break
                    
                case .failure(_):
                    complete(true, arrDatas)
                    break
                }
        }
    }
   
    
    func fetchIngredientbyTypeID(_ id: Int, complete:@escaping (_ success: Bool?, _ arrs: [MainBarObj]?) ->Void)
    {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return
        }
        print(token)
        let auth_headerLogin: HTTPHeaders = ["Authorization": "Token \(token)"]
        manager.request(URL.init(string: "\(URL_SERVER)api/ingredient/brand/type/?type=\(id)&ingredients=true")!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: auth_headerLogin)
            .responseJSON { response in
                print(response)
                var arrDatas = [MainBarObj]()
                switch(response.result) {
                case .success(_):
                    if let code = response.response?.statusCode
                    {
                        if let arrs = response.value as? NSArray
                        {
                            if code == SERVER_CODE.CODE_200
                            {
                                for item in arrs
                                {
                                    let dictItem = item as! NSDictionary
                                    arrDatas.append(MainBarObj.init(dict: dictItem))
                                }
                                complete(true, arrDatas)
                            }
                            else{
                                complete(true, arrDatas)
                            }
                        }
                    }
                    break
                    
                case .failure(_):
                    complete(true, arrDatas)
                    break
                }
        }
    }
    
}
