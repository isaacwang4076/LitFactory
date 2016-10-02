//
//  RequestViewController.swift
//  LitFactory
//
//  Created by Isaac Wang on 10/2/16.
//  Copyright © 2016 DankMemrs. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController{
    
    @IBOutlet var requestTitle: UILabel!
    
    @IBOutlet var requestImage: UIImageView!
    
    @IBOutlet var denyRequest: UIButton!
    @IBAction func approveRequest(_ sender: UIButton) {
        executeApproveRequest(party: Global.parties.value(forKey: notifToDisplay!.partyID) as! Party, approvedID: notifToDisplay!.requesterID)
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    @IBAction func denyRequest(_ sender: UIButton) {
        self.navigationController!.popToRootViewController(animated: true)
    }
    var notifToDisplay: NotificationJoinRequest? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTitle.text = notifToDisplay!.generateMessage()
        requestTitle.numberOfLines = 0;
        requestTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        // set request image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNotification(notif: Notification) {
        notifToDisplay = notif as? NotificationJoinRequest
    }
}
