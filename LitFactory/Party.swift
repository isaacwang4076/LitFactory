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
    let hostID: String!
    let area: String!
    let location: String!
    let name: String!
    var message: String = ""
    
    init(ID: String, hostID: String, area: String, location: String) {
        self.ID = generatePartyID()
        self.hostID = hostID
        self.area = area
        self.location = location
        self.name = generatePartyName();
    }
    
    init(partyDict: NSDictionary) {
        self.ID = partyDict.value(forKey: "ID") as! String!
        self.hostID = partyDict.value(forKey: "hostID") as! String!
        self.area = partyDict.value(forKey: "area") as! String!
        self.location = partyDict.value(forKey: "location") as! String!
        self.name = partyDict.value(forKey: "name") as! String!
        self.message = partyDict.value(forKey: "message") as! String!
    }
    
    func getAsDictionary() -> NSDictionary {
        return [
            "ID": ID,
            "hostID": hostID,
            "area": area,
            "location": location,
            "name": name,
            "message": message]
    }
    
    func setMessage(newMessage: String) {
        message = newMessage
    }
    
    func getID() -> String {
        return ID
    }
    
    func getName() -> String {
        return name
    }
    
    func getHostID() -> String {
        return hostID
    }
}
