//
//  DriverSettings.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 04.05.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit

class DriverSettings: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func GoToSetImage(_ sender: Any) {
        MoveToScene(sceneId: "SetImages")
    }
    
    @IBAction func BackToСhooseType(_ sender: Any) {
        AppData.ClearDB()
        NavigationManager.StopSendLoc()
        NavigationManager.StopTimers()
        MoveToScene(sceneId: "ChooseType")
    }
    
    @IBAction func GoToDonePubs(_ sender: Any) {
        MoveToScene(sceneId: "MyFinishedOrdersListForDriver")
    }
    
    private func MoveToScene(sceneId:String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: sceneId) as! UIViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
}
