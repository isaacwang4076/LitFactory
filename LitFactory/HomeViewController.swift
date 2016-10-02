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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
