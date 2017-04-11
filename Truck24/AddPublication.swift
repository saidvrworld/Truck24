//
//  AddPublication.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation

import UIKit


class AddPublication: UIViewController,UITextFieldDelegate {
    
    var fromLongitude: Float = 69.289002
    var fromLatitude: Float = 41.353516
    var toLongitude: Float = 69.279041
    var toLatitude: Float = 41.364611
    
    var executionDate: String!
    
    @IBOutlet weak var toAddress: UILabel!
    @IBOutlet weak var fromAddress: UILabel!

    @IBOutlet weak var SuccessView: UIView!
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var DateView: UIDatePicker!
    
    @IBOutlet weak var notesView: UITextField!
    var pubManager = PublicationData()
    
    @IBAction func ChooseCarType(_ sender: Any) {
        AppData.lastScene = "AddPublication"
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseCarType") as! ChooseCarType
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func SetFromLocation(_ sender: Any) {
        AppData.waitingForLoc = "FromLoc"
        GoToSetCoordinate()
    }
    
    @IBAction func SetToLocation(_ sender: Any) {
        AppData.waitingForLoc = "ToLoc"
        GoToSetCoordinate()
    }
    
    @IBAction func SetDate(_ sender: Any) {
        
    }
    
    
    func GoToSetCoordinate() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SetCoordinates") as! SetCoordinates
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(AppData.fromLocation != nil){
            pubManager.getAddress(location: AppData.fromLocation,textView: fromAddress)
        }
        if(AppData.toLocation != nil){
        pubManager.getAddress(location: AppData.toLocation,textView: toAddress)
        }
        self.notesView.delegate = self
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func CreatePublication(_ sender: Any) {
        
        LoadingView.isHidden = false
        SuccessView.isHidden = false
        pubManager.AddPub(viewContr: SuccessView, urlAddress: AppData.addPublicationsUrl, token: AppData.token, carTypeId: "1", lat_from: String(fromLatitude), long_from: String(fromLongitude), lat_to: String(toLatitude), long_to: String(toLongitude), notes: notesView.text!, date: getTime())
    }
    
    func getTime()->String{
     
        var dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        var dateInfo = dateFormatter.string(from: DateView.date)
        var dateList = dateInfo.characters.split{$0 == "/"}.map(String.init)
        
        var day = dateList[1]
        var mounth = dateList[0]
        var year = "20"+dateList[2]
        if(Int(day)!<10){
            day = "0"+day
        }
        if(Int(mounth)!<10){
            mounth = "0"+mounth
        }
        var finalDate = day+"."+mounth+"."+year
        return finalDate
    }
    
    @IBAction func BackToMyPub(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    
    
}
