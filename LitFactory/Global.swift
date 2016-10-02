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
    static let database = FIRDatabase.database().reference()
}

func pushUserToFirebase(user: User) {
    Global.database.child("Users").child(user.getID()).setValue(user.getAsDictionary())
}
