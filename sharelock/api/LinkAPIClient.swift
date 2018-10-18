//
//  LinkAPIClient.swift
//  sharelock
//
//  Created by Kimi on 19/10/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import Alamofire

class LinkAPIClient: NSObject {
    
    public static let shared = LinkAPIClient()
    
    private static let kSharelockEndpointKey = "SharelockEndpoint"
    private static let defaultURL = "https://sharelock.io"
    var serverURL = LinkAPIClient.defaultURL
    
    override private init() {}
    
    func generateLinkForSecret(_ secret : Secret, _ callback : @escaping (String?, Error?) -> Void) {
        let parameters = [
            "d": secret.secret,
            "a": secret.allowedViewers.joined(separator: ",")
        ]
        
        Alamofire.request("\(serverURL)/create", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    callback("\(self.serverURL)/\(result)", nil)
                    return
                }
                callback(nil, NSError.init(domain: "LinkAPIClient", code: -1, userInfo: ["response": response]))
            case .failure(let error):
                callback(nil, error)
            }
        }


    }
}
