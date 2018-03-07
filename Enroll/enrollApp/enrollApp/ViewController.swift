//
//  ViewController.swift
//  enrollApp
//
//  Created by Akul  Santhosh on 02/03/18.
//  Copyright © 2018 Akul  Santhosh. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseDatabase

struct KairosConfig {
    static let app_id = "318d9d38"
    static let app_key = "15ca9965e061975c0f7efefb0102371a"
}

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var status: UILabel!
    
    
    var uuid = ""
    
    @IBAction func testing(_ sender: Any){
        let ref = Database.database().reference()
        ref.child("events").setValue(["item_id":0])
    }
    
    
    @IBAction func openLibrary(_ sender: Any) {
        let ref = Database.database().reference()
        ref.child("events").setValue(["item_id":-1])
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        uuid = UUID().uuidString
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let Kairos = KairosAPI(app_id: KairosConfig.app_id, app_key: KairosConfig.app_key)
        let imageData = UIImageJPEGRepresentation(image, 0)
        let base64ImageData = imageData?.base64EncodedString(options:[])
        
        let jsonBody = [
            "image": base64ImageData,
            "gallery_name": "noqstore",
            "subject_id": uuid
        ]
        Kairos.request(method: "enroll", data: jsonBody) { data in
            let json = JSON(data)
                            print(json)
            self.status.text = "Status : Success"
            DispatchQueue.main.sync {
                self.enrollUser()
            }
        }
        
        dismiss(animated:true, completion: nil)
    }
    func enrollUser(){
        let ref = Database.database().reference()
        ref.child("users").child(self.uuid).setValue(
            ["name": self.name.text!,
             "user_id": self.uuid,
             "is_in_store": false,
             "photo": ""])
        self.name.text = ""
    }
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

