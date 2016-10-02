//
//  BrowseSession.swift
//  LitFactory
//
//  Created by Isaac Wang on 10/1/16.
//  Copyright © 2016 DankMemrs. All rights reserved.
//

import Foundation

class BrowseSession {
    let supplies: String?
    let location: (String?, String?)!
    let canHost: Bool!
    
    init (supplies: String?, location: (String?, String?)) {
        self.supplies = supplies
        self.location = location
        
        // if one of the location parts is set, then we are a host
        self.canHost = (location.0 != nil || location.1 != nil)
    }
}
