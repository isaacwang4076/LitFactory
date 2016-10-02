//
//  User.swift
//  LitFactory
//
//  Created by Isaac Wang on 10/1/16.
//  Copyright © 2016 DankMemrs. All rights reserved.
//

import Foundation

class User {
    let ID: String!
    let name: String!
    
    init(ID: String, name: String) {
        self.ID = ID
        self.name = name
    }
    
    func getAsDictionary() -> NSDictionary {
        return [
            "ID": ID,
            "name": name]
    }
    
    func getID() -> String {
        return ID
    }
}
