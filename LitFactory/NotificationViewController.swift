//
//  NotificationViewController.swift
//  LitFactory
//
//  Created by Eric Zhang on 10/2/16.
//  Copyright © 2016 DankMemrs. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let database = Global.database
    var notifs: [Notification] = [Notification]()
    var notifToDisplay: Notification? = nil
    
    @IBOutlet var notificationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pullandDisplayNotifications()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        pullandDisplayNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pullandDisplayNotifications() {
        
        print("*Pulling Notifs...")
        
        database.child("NotifDatabase").child(Global.me.getID()).observeSingleEvent(of: .value, with: {
            (userNotifs) in
            
            //Clear current notifs
            self.notifs = [];
            
            //Redisplay
            for notifSnapshot in userNotifs.children {
                var notif: Notification? = nil
                let notifDict:NSDictionary = (notifSnapshot as! FIRDataSnapshot).value as! NSDictionary
                
                if notifDict.value(forKey: "type") as! Int == Global.TYPE_JOIN_REQ {
                    notif = NotificationJoinRequest(notifDict: notifDict)
                }
                else if notifDict.value(forKey: "type") as! Int == Global.TYPE_JOIN_APP {
                    notif = NotificationJoinApproval(notifDict: notifDict)
                }
                
                print("*", notif?.generateMessage())
                
                self.notifs.insert(notif!, at: 0)
                
            }
            
            // DISPLAY: Once all the Notifications have been pulled, reload the table view
            self.notificationTableView.reloadData()
        })
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationTableViewCell;
        
        let notifToShow: Notification = notifs[indexPath.row]
        cell.label.text = notifToShow.generateMessage()
        cell.label.numberOfLines = 0
        cell.label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        if (notifToShow.viewed == false) {
            cell.backgroundColor = UIColor.blue;
        }
        else {
            cell.backgroundColor = UIColor.white;
        }
        
        return cell
    }
    
    // HANDLE CELL CLICK
    // - Go to corresponding event info page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        notifs[indexPath.row].onNotificationClicked(controller: self, userID: Global.me.getID())
        
        // So when you click someone they aren't highlighted the default grey
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
        tableView.cellForRow(at: indexPath as IndexPath)?.backgroundColor = UIColor.white;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if it's the request segue, set the event id
        if (segue.identifier == "openRequest") {
            (segue.destination as! RequestViewController).hidesBottomBarWhenPushed = true;
            (segue.destination as! RequestViewController).setNotification(notif: self.notifToDisplay!);
        }
    }


}
