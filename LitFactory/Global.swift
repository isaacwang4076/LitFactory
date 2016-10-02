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
    static var parties = NSMutableDictionary();
    
    static var me: User! = User(ID: "userID", name: "Isaac")
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
func getMessages(fromUserWithID: String) {
    Global.database.child("UserIDToConversationIDs").child(Global.me.getID()).observe( .childAdded, with: { (conversationIDsSnapshot) in
        for conversationIDSnapshot in conversationIDsSnapshot.children {
            Global.database.child("Conversations").child((conversationIDSnapshot as! FIRDataSnapshot).value as! String).observeSingleEvent(of: .value, with: {(conversationSnapshot) in
                for messageSnapshot in conversationSnapshot.children {
                    let message = Message(messageDict: (messageSnapshot as! FIRDataSnapshot).value as! NSDictionary)
                    print("\n", message.text)
                }
            })
        }
    })
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
