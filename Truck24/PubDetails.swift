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
    
    @IBOutlet weak var ErrorView: UIView!
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
        
        if let selectedPub = AppData.PubDetailsList[AppData.selectedPubId]{
            FillData( pub: selectedPub)
            self.LoadingView.isHidden = true

        }
        else{
            GetDetails(urlstring: AppData.getPublicationInfoUrl, orderId: String(AppData.selectedPubId))
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func ShowWay(_ sender: Any) {
        AppData.lastScene = "PubDetails"
        NavigationManager.MoveToScene(sceneId: "PubWayOnMap", View: self)
    }
    
   @IBAction func GoToOffers(_ sender: Any) {
    NavigationManager.MoveToScene(sceneId: "OffersList", View: self)
    }
    
    @IBAction func BackToMain(_ sender: Any) {
        NavigationManager.MoveToCustomerMain(View: self)
    }
    
    func GetDetails(urlstring: String,orderId: String){
        
        let parameters = "token=fec5fdf5ac012r43"+orderId+"fec5fdf5ac012r43"
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using: .utf8)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async
                        {
                            self.ErrorView.isHidden = false
                            NavigationManager.ShowError(errorText: "Ошибка соединения!",View: self)
                    }
                }
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
                
                    DispatchQueue.main.async
                        {
                            self.SaveInCach(data: dataBody!)
                            self.LoadingView.isHidden = true
                    }
            }
        }
    }
    
    func SaveInCach(data: [String:Any]){
        let newPub = PubDetail()
        newPub.carTypes = data["carType"] as! String
        
        let type = data["type"] as! Int
        if(type == 1){
            newPub.carTypes = newPub.carTypes + ",Damas Labo(Малотоннажные)"
        }
        else if(type == 2){
            newPub.carTypes = newPub.carTypes + "(Среднетонажные)"
        }
        else if(type == 3){
            newPub.carTypes = newPub.carTypes + "(Тяжелотоннажные)"
        }
        else if(type == 4){
            newPub.carTypes = newPub.carTypes + "(Спец.Техника)"
        }

        newPub.fromLong = data["from_long"] as! Double
        newPub.fromLat = data["from_lat"] as! Double
        newPub.toLong = data["to_long"] as! Double
        newPub.toLat = data["to_lat"] as! Double
        newPub.publicationDate = data["added"] as! String
        newPub.executionDate = data["date"] as! String
        newPub.offerCount = data["offersCount"] as! Int
        newPub.Notes = data["notes"] as! String
        
        AppData.PubDetailsList[data["orderId"] as! Int] = newPub
        FillData(pub: newPub)
    }

    func FillData(pub: PubDetail){
        
        carTypes.text = pub.carTypes
        from_long = pub.fromLong
        from_lat = pub.fromLat
        to_long = pub.toLong
        to_lat = pub.toLat
        publicationDate.text = pub.publicationDate
        Notes.text = pub.Notes
        executionDate.text = pub.executionDate
        offerCount.text = String(describing: pub.offerCount)
        
        AppData.fromLocation = CLLocation(latitude: from_lat, longitude: from_long)
        AppData.toLocation =  CLLocation(latitude: to_lat, longitude: to_long)
        
        pubManager.getAddress(location: AppData.fromLocation,textView: fromAddress)
        pubManager.getAddress(location: AppData.toLocation,textView: toAddress)
        
    }
    

}
