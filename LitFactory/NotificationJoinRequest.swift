//
//  NotificationJoinRequest.swift
//  LitFactory
//
//  Created by Isaac Wang on 10/1/16.
//  Copyright © 2016 DankMemrs. All rights reserved.
//

import Foundation
import FirebaseDatabase

/* Notification for when a user requests to join a party */

class NotificationJoinRequest: Notification {
    
    // Variables (unique to CommentEvent)
    
    let partyID: String!
    let partyName: String!
    let requesterID: String!
    let requesterName: String!
    let proofPhotoID: String!
    let supplies: String!
    
    // NEW NOTIFICATION CONSTRUCTOR
    // - Sets all variables and generates new notifID
    init(type: Int, pictureID: String, partyID: String, partyName: String, requesterID: String,requesterName: String, proofPhotoID: String!, supplies: String?) {

        // Unique variables instantiation
        self.partyID = partyID
        self.partyName = partyName
        self.requesterID = requesterID
        self.requesterName = requesterName
        self.proofPhotoID = proofPhotoID
        if (supplies == nil || supplies == "") {
            self.supplies = "nothing"
        } else {
            self.supplies = supplies
        }
        
        // Superclass constructor
        super.init(type: type, pictureID: pictureID)
    }
    
    // EXISTING NOTIFICATION CONSTRUCTOR
    // - Sets all variables (copies existing NotifID)
    init(notifDict: NSDictionary) {
        
        // Unique variables instantiation
        self.partyID = notifDict.value(forKey: "partyID") as! String
        self.partyName = notifDict.value(forKey: "partyName") as! String
        self.requesterID = notifDict.value(forKey: "requesterID") as! String
        self.requesterName = notifDict.value(forKey: "requesterName") as! String
        self.proofPhotoID = notifDict.value(forKey: "proofPhotoID") as! String
        self.supplies = notifDict.value(forKey: "supplies") as! String?
        
        // Superclass constructor
        super.init(type: notifDict.value(forKey: "type") as! Int, pictureID: notifDict.value(forKey: "pictureID") as! String, notifID: notifDict.value(forKey: "notifID") as! String)
        
        self.viewed = notifDict.value(forKey: "viewed") as! Bool
    }
    
    // OVERRIDE SUPERCLASS METHODS ----------------------------------------------------------------------
    
    
    override func convertToDictionary(notif: Notification) -> NSDictionary {
        
        // Store unique variables
        let notifDict: NSMutableDictionary = ["partyID": (notif as! NotificationJoinRequest).partyID, "partyName": (notif as! NotificationJoinRequest).partyName, "requesterID": (notif as! NotificationJoinRequest).requesterID, "requesterName": (notif as! NotificationJoinRequest).requesterName, "proofPhotoID": (notif as! NotificationJoinRequest).proofPhotoID, "supplies": (notif as! NotificationJoinRequest).supplies]
        
        // Store common variables
        notifDict.addEntries(from: super.convertToDictionary(notif: notif) as [NSObject : AnyObject])
        
        return notifDict
    }
    
    override func hasConflict(userNotifs: FIRDataSnapshot) -> (FIRDataSnapshot, FIRDatabaseReference)? {
        
        // Iterate through the user's Notifications
        for notifSnap in userNotifs.children {
            let notifMap: NSDictionary = (notifSnap as! FIRDataSnapshot).value as! NSDictionary
            
            // Check Notification type
            if (notifMap.value(forKey: "type") as! Int != Global.TYPE_JOIN_REQ) {
                continue
            }
            
            // Check eventID
            let njr: NotificationJoinRequest =  NotificationJoinRequest(notifDict: notifMap)
            if (njr.requesterID == self.requesterID && njr.partyID == self.partyID) {
                
                // Conflict found
                return (notifSnap as! FIRDataSnapshot, (notifSnap as! FIRDataSnapshot).ref)
            }
        }
        
        // No conflicts found
        return nil
    }
    
    override func handleConflict(snapToBase: (FIRDataSnapshot, FIRDatabaseReference)) -> Notification? {
        
        // Do nothing in the case of a conflict
        return nil
    }
    
    // --------------------------------------------------------------------------------------------------------
    
    // IMPLEMENT PROTOCOL METHODS -----------------------------------------------------------------------------
    
    override func onNotificationClicked(controller: NotificationViewController, userID: String) {
        if (!viewed) {
            // Set the local Notification to viewed
            self.viewed = true
        
            // Set the Notification on the database to viewed
            setToViewed(userID: userID)
        
            // Navigate to EventInfo for event
            controller.notifToDisplay = self
            controller.performSegue(withIdentifier: "openRequest", sender: controller);
        }
        
    }
    
    override func generateMessage() -> String {
        var message = requesterName + " has requested to join " + partyName
        if (supplies != nil) {
            message += ". He\'s bringing " + supplies!
        }
        message += "."
        return message;
    }
    // --------------------------------------------------------------------------------------------------------
    
}
