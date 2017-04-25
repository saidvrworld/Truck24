//
//  PublicationData.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class PublicationData{
    
    
    func GetMyPub(table: UITableView,urlAddress: String,token:String){
        
        let parameters = "token="+token
        print(parameters)
        let url = URL(string: urlAddress)
        var request = URLRequest(url: (url)!)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    AppData.PubList = self.GetMyPubResponse(response:responseJSON)
                    DispatchQueue.main.async
                        {
                            table.reloadData()
                    }
                    
                }
            }
        }
        
        task.resume()
        
    }
    
    func AddPub(viewContr: UIView,urlAddress: String,token:String,carTypeId:String,lat_from:String,long_from:String,lat_to:String,long_to:String,notes:String,date:String){
        
        let parameters = "token="+token+"&carTypeId="+carTypeId+"&lat_from="+lat_from+"&long_from="+long_from+"&lat_to="+lat_to+"&long_to="+long_to+"&notes="+notes+"&date="+date
        
        print(parameters)
        let url = URL(string: urlAddress)
        var request = URLRequest(url: (url)!)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                self.AddPublicationResponse(response:responseJSON,viewControler: viewContr)
                //viewContr.reloadData()
            }
        }
        
        task.resume()
        
    }
    
    func GetMyPubResponse(response:[String:Any])->[Publication]{
        var pubList:[Publication] = []
        
        if let array = response["data"] as? [Any] {
            
            for pubObj in array {
                let dataBody = pubObj as? [String: Any]
                print(dataBody)
                pubList.append(ParsePub(dataBody! as [String : AnyObject]))
                
            }
        }
        return pubList
        
    }
    
    
    func AddPublicationResponse(response:[String:Any],viewControler: UIView){
        
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                print(dataBody)
                var success = dataBody?["success"] as! Bool
                if(success){
                    viewControler.isHidden = false
                }
                else{
                    
                    print("error")
                }
            }
        }
        
    }
    
    func getAddress(location: CLLocation,textView:UILabel){
        var fullAddress:String = " "
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                print(locationName)
                fullAddress = (locationName as! String)
                textView.text = fullAddress

            }
            
        })

    }
    
    
    func ParsePub(_ pub:[String:AnyObject])->Publication{
        let newPub = Publication()
        newPub.carType = pub["carType"] as! String
        newPub.notes = pub["notes"] as! String
        newPub.date_of_publication = pub["date"] as! String
        newPub.pubId = pub["orderId"] as! Int
        newPub.status = pub["status"] as! Int
        return newPub
    }




}
