//
//  LinkAPIClient.swift
//  sharelock
//
//  Created by Kimi on 19/10/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics

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
                    if let url = URL.init(string: "\(self.serverURL)/\(result)") {
                        callback(url.absoluteString, nil)
                        return
                    }
                    callback(nil, APIError.init(str: result))
                    return
                }
                callback(nil, APIError.init(str: "Sorry, there was an unknown error."))
            case .failure(let error):
                Crashlytics.sharedInstance().recordError(error)
                callback(nil, APIError.init(str: "Sorry, there was a server error."))
            }
        }


    }
}
