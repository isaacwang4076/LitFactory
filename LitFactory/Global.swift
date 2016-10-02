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
    static var me: User! = User(ID: "userID", name: "Isaac")
    static var parties = NSMutableDictionary();
    static var browseSession: BrowseSession = BrowseSession(supplies: nil, location: (nil,nil))
    
    // NOTIFICATION TYPE
    static let TYPE_JOIN_REQ = 0;
    static let TYPE_JOIN_APP = 1;
}

func setParty(party: Party) {
    Global.parties[party.getID()] = party;
}

func addAttendee(attendeeID: String, partyID: String) {
    Global.database.child("PartyIDToAttendeeIDs").child(partyID).childByAutoId().setValue(attendeeID);
}

func pushUserToFirebase(user: User) {
    Global.database.child("Users").child(user.getID()).setValue(user.getAsDictionary())
}

func pushEventToFirebase(party: Party) {
    Global.database.child("Parties").child(party.getID()).setValue(party.getAsDictionary())
}

// adds a message to the database
func pushMessageToFirebase(message: Message) {
    
    // unique conversation ID composed of the two User's ID's in alphabetical order
    let conversationID = combineUserIDs(ID1: message.getSenderID(), ID2: message.getReceiverID())
    
    // add the message to the conversation
    Global.database.child("Conversations").child(conversationID).childByAutoId().setValue(message.getAsDictionary())
    
    // check to see if the two have an existing conversation
    Global.database.child("UserIDToConversationIDs").child(message.getSenderID()).observe(.value, with: {
        (conversationIDsSnapshot) in
        for conversationIDSnapshot in conversationIDsSnapshot.children {
            if ((conversationIDSnapshot as! FIRDataSnapshot).value as! String == conversationID) {
                return;
            }
        }
        
        // if not, add this conversation to their conversations
        Global.database.child("UserIDToConversationIDs").child(message.getSenderID()).childByAutoId().setValue(conversationID)
        Global.database.child("UserIDToConversationIDs").child(message.getReceiverID()).childByAutoId().setValue(conversationID)
    })
}

// untested
func getMessages() {
    Global.database.child("UserIDToConversationIDs").child(Global.me.getID()).observe(.value, with: { (conversationIDsSnapshot) in
        for conversationIDSnapshot in conversationIDsSnapshot.children.allObjects {
            Global.database.child("Conversations").child((conversationIDSnapshot as! FIRDataSnapshot).value as! String).observeSingleEvent(of: .value, with: {(conversationSnapshot) in
                for messageSnapshot in conversationSnapshot.children.allObjects {
                    let messageDict: NSDictionary = (messageSnapshot as! FIRDataSnapshot).value as! NSDictionary
                    let message = Message(messageDict: messageDict)
                    print("\n*Text is :", message.getText())
                }
            })
        }
    })
}

func sendNJR(party: Party) {
    let njr = NotificationJoinRequest(type: Global.TYPE_JOIN_REQ, pictureID: Global.me.getID(), partyID: party.getID(), partyName: party.getName(), requesterID: Global.me.getID(), requesterName: Global.me.getName(), supplies: Global.browseSession.supplies)
    njr.pushToFirebase(usersWhoCare: [party.getHostID()])
}

func sendNJA(party: Party, approvedID: String) {
    let nja = NotificationJoinApproval(type: Global.TYPE_JOIN_APP, pictureID: party.getHostID(), partyID: party.getID(), partyName: party.getName(), approverName: Global.me.getName())
    nja.pushToFirebase(usersWhoCare: [approvedID])
}

// returns unique ID composed of two User's ID's in alphabetical order
func combineUserIDs(ID1: String, ID2: String) -> String {
    if (ID1.compare(ID2).rawValue == -1) {
        return ID1 + ID2;
    }
    return ID2 + ID1;
}

func generateEventName() -> String {
    return ""
}

func generateMessageID() -> String {
    return "messageID"
}

func generateNotifID() -> String {
    let newID = " "
    return newID
}
