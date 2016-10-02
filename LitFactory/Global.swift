//
//  Global.swift
//  LitFactory
//
//  Created by Isaac Wang on 10/1/16.
//  Copyright © 2016 DankMemrs. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Global {
    static let database: FIRDatabaseReference = FIRDatabase.database().reference()
    static var parties = NSDictionary();
}

func setParty(party: Party) {
    Global.parties.setValue(party, forKey: party.getID())
}

func pushUserToFirebase(user: User) {
    Global.database.child("Users").child(user.getID()).setValue(user.getAsDictionary())
}

func pushEventToFirebase(party: Party) {
    Global.database.child("Parties").child(party.getID()).setValue(party.getAsDictionary())
}

func generateEventName() -> String {
    return ""
}
