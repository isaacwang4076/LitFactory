//
//  FirstViewController.swift
//  LitFactory
//
//  Created by Isaac Wang on 10/1/16.
//  Copyright © 2016 DankMemrs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // First pull
        Global.database.child("Parties").observeSingleEvent(of: .value, with: { (partiesSnapshot) in
            for partySnapshot in partiesSnapshot.children {
                let partyDict:NSDictionary = (partySnapshot as! FIRDataSnapshot).value as! NSDictionary
                let party:Party = Party(partyDict: partyDict)
                setParty(party: party)
                print("\n*Value: Party has ID", party.getID(), "parties length is now", Global.parties.count)
            }
        })
        
        // Listener for new party
        Global.database.child("Parties").observe(.childAdded, with: {(partySnapshot) -> Void in
            let partyDict:NSDictionary = (partySnapshot).value as! NSDictionary
            let party:Party = Party(partyDict: partyDict)
            setParty(party: party)
            print("\n*ChildAdded: Party has ID ", party.getID())
        })
        
        // Listener for party change
        Global.database.child("Parties").observe(.childChanged, with: {(partySnapshot) -> Void in
            let partyDict:NSDictionary = (partySnapshot).value as! NSDictionary
            let party:Party = Party(partyDict: partyDict)
            setParty(party: party)
            print("\n*ChildChanged: Party has ID ", party.getID())
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

