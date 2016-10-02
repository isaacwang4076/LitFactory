//
//  HomeViewController.swift
//  LitFactory
//
//  Created by Eric Zhang on 10/1/16.
//  Copyright © 2016 DankMemrs. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var bringingText: UITextField!
    @IBOutlet var genLocationText: UITextField!
    @IBOutlet var specLocationText: UITextField!
    
    @IBAction func turnup(_ sender: AnyObject) {
        if (self.bringingText.text?.isEmpty)! {
            print("* no bringing text")
            //alert
        }
        else {
            if ((self.genLocationText.text?.isEmpty)! && (specLocationText.text?.isEmpty)!) {
                print ("* go to join party")
                performSegue(withIdentifier: "showParties", sender: self)
            }
            else if ((self.genLocationText.text?.isEmpty)! || (self.specLocationText.text?.isEmpty)!) {
                print ("* attempting to host, but haven't provided complete loc.")
            }
            else {
                print ("* go to host page")
                performSegue(withIdentifier: "showPictureProof", sender: self)
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //transfer party info to photoVC
        if segue.identifier == "showPictureProof" {
            (segue.destination as! PhotoViewController).partyToUpload = Party.init(ID: "69420", hostID: "my_id", area: self.genLocationText.text!, location: self.specLocationText.text!)
        }
    }
    

}
