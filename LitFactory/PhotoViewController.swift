//
//  PhotoViewController.swift
//  LitFactory
//
//  Created by Eric Zhang on 10/1/16.
//  Copyright © 2016 DankMemrs. All rights reserved.
//

import UIKit
import Firebase

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var partyToUpload: Party! = Party.init(ID: "dank memr", hostID: "host id", area: "marshall", location: "e-02")

    @IBOutlet var litPhoto: UIImageView!
    @IBAction func takePhoto(_ sender: AnyObject) {
        //check if camera functionality available
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            //imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.litPhoto.image = image
        self.dismiss(animated: true, completion: nil);
    }
    @IBAction func createParty(_ sender: AnyObject) {
        if self.litPhoto.image != nil {
            //upload to firebase
            let ID = "random ID"
            let partyToUpload = Party.init(ID: ID, hostID: "host id", area: "marshall", location: "e-02")
            let pictureData = UIImagePNGRepresentation(self.litPhoto.image!)
            Global.storage.child("partyImages/\(partyToUpload.ID!).png").put(pictureData!)
            pushEventToFirebase(party: partyToUpload)
        }
        else {
            //alert user about no photo
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
