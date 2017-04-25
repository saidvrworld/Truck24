//
//  OrderDetails.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 10.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class OrderDetails: UIViewController {
    
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var publicationDate: UILabel!
    @IBOutlet weak var carTypes: UILabel!
    @IBOutlet weak var fromAddress: UILabel!
    @IBOutlet weak var toAddress: UILabel!
    @IBOutlet weak var Notes: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var OfferButton: UIButton!
    
    @IBOutlet weak var executionDate: UILabel!
    
    var from_long:Double!
    var from_lat:Double!
    var to_long:Double!
    var to_lat:Double!
    
    var cur_status:Int = 0
    
    var pubManager = PublicationData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetDetails(urlstring: AppData.getOrderInfoForDriverUrl, orderId: String(AppData.selectedOrderForDriverId),token: AppData.token)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func GoToOfferPrice(_ sender: Any) {
        if(cur_status == 0){
           MakeOffer()
        }
        else if(cur_status == 1){
           print("You already send")
           UpdateOfferButtonStatus()
        }
        else if(cur_status == 2){
             EndOrder(urlstring: AppData.closeOrderDriverUrl, orderId: String(AppData.selectedOrderForDriverId), token: AppData.token)
        }
        
    }
    
    private func MakeOffer(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let PopView = storyBoard.instantiateViewController(withIdentifier: "OfferPrice") as! OfferPrice
        self.addChildViewController(PopView)
        PopView.view.frame = self.view.frame
        self.view.addSubview(PopView.view)
        PopView.didMove(toParentViewController: self)
    }
    
    @IBAction func MakeCall(_ sender: Any) {
        
        if var number = customerPhone.text{
            callNumber(phoneNumber: number)
        }
    }
    
    
    
    
    
    @IBAction func ShowWay(_ sender: Any) {
        AppData.lastScene = "OrderDetails"
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PubWayOnMap") as! PubWayOnMap
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    
    
    @IBAction func BackToMain(_ sender: Any) {
        GoToMain()
    }
    
    private func GoToMain(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainDriverView") as! UITabBarController
        self.present(nextViewController, animated:true, completion:nil)

    }
    
    
    private func GetDetails(urlstring: String,orderId: String,token: String){
        
        let parameters = "token=fec5fdf5ac012r43"+orderId+"fec5fdf5ac012r43"+"&userToken="+token
        
        print(parameters)
        
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    self.InfoManager(response:responseJSON)
                    DispatchQueue.main.async
                        {
                            self.LoadingView.isHidden = true
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
    private func EndOrder(urlstring: String,orderId: String,token: String){
        
        let parameters = "token=fec5fdf5ac012r43"+orderId+"fec5fdf5ac012r43"+"&userToken="+token
        
        print(parameters)
        
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                if let array = responseJSON["data"] as? [Any] {
                    if let firstObject = array.first {
                        let dataBody = firstObject as? [String: Any]
                        var success = dataBody?["success"] as! Bool
                        if(success){
                            print("You close this order")
                            self.GoToMain()
                        }
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
    private func InfoManager(response: [String:Any]){
        
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                print(dataBody)
                carTypes.text = dataBody?["carType"] as! String
                from_long = dataBody?["from_long"] as! Double
                from_lat = dataBody?["from_lat"] as! Double
                to_long = dataBody?["to_long"] as! Double
                to_lat = dataBody?["to_lat"] as! Double
                publicationDate.text = dataBody?["added"] as! String
                
                
                AppData.fromLocation = CLLocation(latitude: from_lat, longitude: from_long)
                AppData.toLocation =  CLLocation(latitude: to_lat, longitude: to_long)
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    self.pubManager.getAddress(location: AppData.fromLocation,textView: self.fromAddress)
                    self.pubManager.getAddress(location: AppData.toLocation,textView: self.toAddress)
                    DispatchQueue.main.async
                        {
                            self.Notes.text = dataBody?["notes"] as! String
                            self.executionDate.text = dataBody?["date"] as! String
                            self.customerName.text = dataBody?["customerName"] as! String
                            self.customerPhone.text = dataBody?["customerPhoneNumber"] as! String
                            var status = dataBody?["status"] as! Int
                            self.cur_status = status
                            self.UpdateOfferButtonStatus()                    }
                }
                
            }
            
        }
        
    }
    
    private func UpdateOfferButtonStatus(){
        if(cur_status == 0){
            self.OfferButton.setTitle("Предложить цену", for: .normal)
        }
        else if(cur_status == 1){
            self.OfferButton.setTitle("Ожидается", for: .normal)
        }
        else if(cur_status == 2){
            self.OfferButton.setTitle("Окончить", for: .normal)
        }
    }
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                application.openURL(phoneCallURL as URL);
            }
        }
    }
    
    
    
}
