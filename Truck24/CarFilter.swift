//
//  CarFilter.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit


class CarFilter: UIViewController {
    
    
    @IBOutlet weak var RadiusSlider: UISlider!
    
    @IBOutlet weak var radius: UILabel!
    
    
    @IBAction func ChooseCarType(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseCarType") as! ChooseCarType
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func SetLocation(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SetCoordinates") as! SetCoordinates
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func SetRadius(_ sender: Any) {
        radius.text = String(RadiusSlider.value)+" км"
        
    }
    
    @IBAction func ShowResult(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func BackToSignIn(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    
    
}
