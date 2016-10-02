//
//  PartyInfoViewController.swift
//  LitFactory
//
//  Created by Eric Zhang on 10/1/16.
//  Copyright © 2016 DankMemrs. All rights reserved.
//

import UIKit
import Firebase

class PartyInfoViewController: UIViewController {
    
    @IBOutlet var partyName: UILabel!
    @IBOutlet var genLocation: UILabel!
    @IBOutlet var partyImage: UIImageView!
    @IBOutlet var partyMessage: UITextView!
    @IBAction func join(_ sender: AnyObject) {
        sendNJR(party: partyList[currentPartyIndex])
        self.showNextParty()
    }
    @IBAction func naw(_ sender: AnyObject) {
        self.showNextParty()
    }
    @IBAction func reset(_ sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    var partyID:String?
    
    func showNextParty() {
        if !self.partyList.isEmpty {
            currentPartyIndex += 1
            if currentPartyIndex >= self.partyList.count {
                currentPartyIndex = 0
            }
            self.showPartyInfo()
        }
    }
    
    func showPartyInfo() {
        let party = partyList[currentPartyIndex]
        self.partyName.text = party.name
        self.genLocation.text = party.area
        self.partyMessage.text = party.message
        Global.storage.child("partyImages/\(party.ID!).png").data(withMaxSize: 100*1024*1024, completion: {
            (data, error) in
            if data != nil {
                self.partyImage.image = UIImage(data: data!)
            }
            else {
                print ("* no party photo")
            }
        })
    }
    
    func showPartyInfo(partyID: String?) {
        
        var party: Party?
        if (partyID != nil) {
            self.currentPartyIndex = 0;
            for partySearch in partyList {
                if (partySearch.getID() == partyID) {
                    party = partySearch
                    break
                }
            
                self.currentPartyIndex += 1
            }
        
            if (party == nil) {
                // show message party doesn't exist
            
                currentPartyIndex = 0
                showPartyInfo()
                return
            }
        } else {
            party = partyList[currentPartyIndex]
        }
        
        self.partyName.text = party!.name
        self.genLocation.text = party!.area
        self.partyMessage.text = party!.message
        Global.storage.child("partyImages/\(party!.ID!).png").data(withMaxSize: 100*1024*1024, completion: {
            (data, error) in
            if data != nil {
                self.partyImage.image = UIImage(data: data!)
            }
            else {
                print ("* no party photo")
            }
        })
    }
    
    
    var partyList:[Party] = []
    var currentPartyIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Global.database.child("Parties").observeSingleEvent(of: .value, with: {
            (snapshot) in
            let partySnapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
            print ("*hi")
            if partySnapshots != nil {
                print ("*hi")
                for eachPartySnapshot in partySnapshots! {
                    let party = Party.init(partyDict: eachPartySnapshot.value as! NSDictionary)
                    self.partyList.append(party)
                }
                
                self.showPartyInfo(partyID: self.partyID)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
