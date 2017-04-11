//
//  PubDetails.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 09.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class PubDetails: UIViewController {
    
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var publicationDate: UILabel!
    @IBOutlet weak var carTypes: UILabel!
    @IBOutlet weak var fromAddress: UILabel!
    @IBOutlet weak var toAddress: UILabel!
    @IBOutlet weak var offerCount: UILabel!
    @IBOutlet weak var Notes: UILabel!
    
    @IBOutlet weak var executionDate: UILabel!
    
    var from_long:Double!
    var from_lat:Double!
    var to_long:Double!
    var to_lat:Double!
    
    var pubManager = PublicationData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetDetails(urlstring: AppData.getPublicationInfo, orderId: String(AppData.selectedPubId))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    
    
    
    @IBAction func ShowWay(_ sender: Any) {
        AppData.lastScene = "PubDetails"
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PubWayOnMap") as! PubWayOnMap
        self.present(nextViewController, animated:true, completion:nil)

    }
    
   @IBAction func GoToOffers(_ sender: Any) {
       let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
       let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OffersList") as! OffersList
       self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func BackToMain(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
            self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    
    func GetDetails(urlstring: String,orderId: String){
        
        let parameters = "token=fec5fdf5ac012r43"+orderId+"fec5fdf5ac012r43"
        
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
                self.InfoManager(response:responseJSON)
            }
        }
        
        task.resume()
        
    }
    
    func InfoManager(response: [String:Any]){
        
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                
                carTypes.text = dataBody?["carType"] as! String
                from_long = dataBody?["from_long"] as! Double
                from_lat = dataBody?["from_lat"] as! Double
                to_long = dataBody?["to_long"] as! Double
                to_lat = dataBody?["to_lat"] as! Double
                publicationDate.text = dataBody?["added"] as! String

                
                AppData.fromLocation = CLLocation(latitude: from_lat, longitude: from_long)
                AppData.toLocation =  CLLocation(latitude: to_lat, longitude: to_long)
                
                pubManager.getAddress(location: AppData.fromLocation,textView: fromAddress)
                pubManager.getAddress(location: AppData.toLocation,textView: toAddress)

                Notes.text = dataBody?["notes"] as! String
                executionDate.text = dataBody?["date"] as! String
                offerCount.text = String(dataBody?["offersCount"] as! Int)
                
                LoadingView.isHidden = true
            }
            
        }
        
    }

    
    
}
