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
    
    func register(_ para: Parameters, complete:@escaping (_ success: Bool?, _ errer: ErrorModel?) ->Void) {
        
        manager.request(URL.init(string: "\(URL_SERVER)api/user/signup/")!, method: .post, parameters: para,  encoding: URLEncoding(destination: .methodDependent), headers: auth_headerLogin)
            .responseJSON { response in
                print(response.response?.statusCode)
                switch(response.result) {
                case .success(_):
                     let value = response.result.value  as! NSDictionary
                     if let sucess = value["isSuccess"] as? Bool
                     {
                        if sucess
                        {
                             complete(true, nil)
                        }
                        else{
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: value["notification"] as? String))
                        }
                     }
                    
                    print(value)
                case .failure(let error):
                    complete(false, ErrorManager.processError(error: error))
                    
                    
                }
        }
        
    }
   
}
