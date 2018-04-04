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
}
