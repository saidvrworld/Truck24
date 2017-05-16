//
//  SetImages.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 04.05.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit

class SetImages: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var carImage: UIImageView!
    var waiting_for:String?
    let imagePicker = UIImagePickerController()
    
    @IBAction func ChooseUserImage(_ sender: Any) {
        waiting_for = "user"
        SetUserImage()
    }
    
    @IBAction func ChooseCarImage(_ sender: Any) {
        waiting_for = "car"
        SetUserImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

     }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func SetUserImage(){
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    
    }
    
    @IBAction func BackButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainDriverView") as! UITabBarController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if(waiting_for=="user"){
                userImage.contentMode = .scaleAspectFit
                userImage.image = pickedImage
            }
            else if(waiting_for=="car"){
                carImage.contentMode = .scaleAspectFit
                carImage.image = pickedImage

            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
