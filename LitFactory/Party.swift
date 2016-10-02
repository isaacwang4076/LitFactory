//
//  Party.swift
//  LitFactory
//
//  Created by Isaac Wang on 10/1/16.
//  Copyright © 2016 DankMemrs. All rights reserved.
//

import Foundation

class Party {
    let ID: String!
    let host: String!
    let area: String!
    let location: String!
    let name: String!
    var message: String = ""
    
    init(ID: String, host: String, area: String, location: String) {
        self.ID = ID
        self.host = host
        self.area = area
        self.location = location
        self.name = generateEventName();
    }
    
    init(partyDict: NSDictionary) {
        self.ID = partyDict.value(forKey: "ID") as! String!
        self.host = partyDict.value(forKey: "host") as! String!
        self.area = partyDict.value(forKey: "area") as! String!
        self.location = partyDict.value(forKey: "location") as! String!
        self.name = partyDict.value(forKey: "name") as! String!
        self.message = partyDict.value(forKey: "message") as! String!
    }
    
    func getAsDictionary() -> NSDictionary {
        return [
            "ID": ID,
            "host": host,
            "area": area,
            "location": location,
            "name": name,
            "message": message]
    }
    
    func setMessage(newMessage: String) {
        message = newMessage
    }
    
    func getID() -> String {
        return ID;
    }
}
