//
//  Secret.swift
//  sharelock
//
//  Created by Kimi on 19/10/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit

class Secret: NSObject {
    
    public static let secretClearedNotification = Notification.init(name: Notification.Name.init("SecretCleared"))
    public static var current: Secret?
    
    private(set) var secret = ""
    private(set) var allowedViewers = [String]()
    private(set) var link = ""
    
    init(secret : String) {
        self.secret = secret
    }
    
    func addLink(link : String) {
        self.link = link
    }
    
    func replace(allowedViewers : [String]) {
        self.allowedViewers = allowedViewers
    }
    
    func clear() {
        self.secret = ""
        self.allowedViewers.removeAll()
        self.link = ""
        NotificationCenter.default.post(Secret.secretClearedNotification)
    }
    
}
