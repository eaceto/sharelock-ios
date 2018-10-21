//
//  APIError.swift
//  sharelock
//
//  Created by Kimi on 21/10/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit

class APIError: LocalizedError, CustomStringConvertible {
        
    let desc: String
    
    init(str: String) {
        desc = str
    }
    
    var description: String {
        return desc
    }
    
    var localizedDescription: String {
        let format = NSLocalizedString("%@", comment: "Error description")
        return String.localizedStringWithFormat(format, desc)
    }
    
}
