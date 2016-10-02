//
//  NotificationJoinApproval.swift
//  LitFactory
//
//  Created by Isaac Wang on 10/1/16.
//  Copyright © 2016 DankMemrs. All rights reserved.
//

import Foundation
import FirebaseDatabase

/* Notification for when a user requests to join a party */

class NotificationJoinApproval: Notification {
    
    // Variables (unique to CommentEvent)
    
    let partyID: String!
    let partyName: String!
    let approverName: String!
    
    // NEW NOTIFICATION CONSTRUCTOR
    // - Sets all variables and generates new notifID
    init(type: Int, pictureID: String, partyID: String, partyName: String, approverName: String) {
        
        // Unique variables instantiation
        self.partyID = partyID
        self.partyName = partyName
        self.approverName = approverName
        
        // Superclass constructor
        super.init(type: type, pictureID: pictureID)
    }
    
    // EXISTING NOTIFICATION CONSTRUCTOR
    // - Sets all variables (copies existing NotifID)
    init(notifDict: NSDictionary) {
        
        // Unique variables instantiation
        self.partyID = notifDict.value(forKey: "partyID") as! String
        self.partyName = notifDict.value(forKey: "partyName") as! String
        self.approverName = notifDict.value(forKey: "approverName") as! String
        
        // Superclass constructor
        super.init(type: notifDict.value(forKey: "type") as! Int, pictureID: notifDict.value(forKey: "pictureID") as! String, notifID: notifDict.value(forKey: "notifID") as! String)
        
        self.viewed = notifDict.value(forKey: "viewed") as! Bool
    }
    
    // OVERRIDE SUPERCLASS METHODS ----------------------------------------------------------------------
    
    
    override func convertToDictionary(notif: Notification) -> NSDictionary {
        
        // Store unique variables
        let notifDict: NSMutableDictionary = ["partyID": (notif as! NotificationJoinApproval).partyID, "partyName": (notif as! NotificationJoinApproval).partyName, "approverName": (notif as! NotificationJoinApproval).approverName]
        
        // Store common variables
        notifDict.addEntries(from: super.convertToDictionary(notif: notif) as [NSObject : AnyObject])
        
        return notifDict
    }
    
    override func hasConflict(userNotifs: FIRDataSnapshot) -> (FIRDataSnapshot, FIRDatabaseReference)? {
        
        // Iterate through the user's Notifications
        for notifSnap in userNotifs.children {
            let notifMap: NSDictionary = (notifSnap as! FIRDataSnapshot).value as! NSDictionary
            
            // Check Notification type
            if (notifMap.value(forKey: "type") as! Int != Global.TYPE_JOIN_APP) {
                continue
            }
            
            // Check eventID
            let nja: NotificationJoinApproval =  NotificationJoinApproval(notifDict: notifMap)
            if (nja.partyID == self.partyID) {
                
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
    
    /*override func onNotificationClicked(controller: NotificationViewController, userID: String) {
     
     // Set the local Notification to viewed
     self.viewed = true
     
     // Set the Notification on the database to viewed
     setToViewed(userID)
     
     // Navigate to EventInfo for event
     controller.selectedPartyID = partyID
     controller.performSegueWithIdentifier("openEventInfo", sender: controller);
     }*/
    
    override func generateMessage() -> String {
        return approverName + " has confirmed your request to join " + partyName
    }
    // --------------------------------------------------------------------------------------------------------
    
}
