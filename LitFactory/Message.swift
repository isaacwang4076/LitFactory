//
//  Message.swift
//  LitFactory
//
//  Created by Isaac Wang on 10/1/16.
//  Copyright © 2016 DankMemrs. All rights reserved.
//

import Foundation

class Message {
    
    let text: String!
    let senderID: String!
    let receiverID: String!
    
    init(text: String, senderID: String, receiverID: String) {
        self.text = text
        self.senderID = senderID
        self.receiverID = receiverID
    }
    
    init(messageDict: NSDictionary) {
        self.text = messageDict.value(forKey: "text") as! String
        self.senderID = messageDict.value(forKey: "senderID") as! String
        self.receiverID = messageDict.value(forKey: "receiverID") as! String
    }
    
    func getAsDictionary() -> NSDictionary {
        return [
            "text": text,
            "senderID": senderID,
            "receiverID": receiverID]
    }
    
    func getText() -> String { return text }
    
    func getSenderID() -> String { return senderID }
    
    func getReceiverID() -> String { return receiverID }
}
