//
//  AppDelegate.swift
//  LitFactory
//
//  Created by Isaac Wang on 10/1/16.
//  Copyright © 2016 DankMemrs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    override init() {
        super.init()
        FIRApp.configure()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //let isaac = User(ID: "userID3", name: "Isaac3")
        let party = Party(hostID: "userID", area: "area2", location: "location2")
        
        //pushUserToFirebase(user: isaac)
        pushEventToFirebase(party: party)
        
        //addAttendee(attendeeID: "userID2", partyID: "partyID2")
        
        //let message = Message(text: "This is the text ayy", senderID: "userID", receiverID: "userID3")
        
        //pushMessageToFirebase(message: message)
        
        //getMessages()
        
        /*let nja = NotificationJoinApproval(type: Global.TYPE_JOIN_APP, pictureID: "userID", partyID: "partyID", partyName: "partyName", approverName: "Isaac1")
        nja.pushToFirebase(usersWhoCare: ["userID"])*/
        
        //sendNJR(party: party)
        //sendNJA(party: party, approvedID: "userID")
        
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
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

