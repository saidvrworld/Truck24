//
//  OrderForDriverData.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 10.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation



import Foundation
import UIKit
import MapKit
import CoreLocation

class OrderForDriverData{
    
    
     func GetOrderList(table: UITableView,urlAddress: String,token:String){
        
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
                AppData.OrderForDriverList = self.GetOrderResponse(response:responseJSON)
                table.reloadData()
            }
        }
        
        task.resume()
        
    }
    
    private func GetOrderResponse(response:[String:Any])->[OrderForDriver]{
        var orderList:[OrderForDriver] = []
        
        if let array = response["data"] as? [Any] {
            
            for orderObj in array {
                let dataBody = orderObj as? [String: Any]
                print(dataBody)
                orderList.append(ParseOrder(dataBody! as [String : AnyObject]))
                
            }
        }
        return orderList
        
    }
    
    
    
    func getAddress(location: CLLocation,text:String){
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
                
            }
            
        })
        
    }
    
    
   private func ParseOrder(_ order:[String:AnyObject])->OrderForDriver{
        let newOrder = OrderForDriver()
        newOrder.orderId = order["orderId"] as! Int
        newOrder.notes = order["notes"] as! String
        newOrder.date_of_execution = order["date"] as! String
    
        var from_lat = order["from_lat"] as! Double
        var from_long = order["from_long"] as! Double

        newOrder.addressFrom = "Юнусабад"
        var addressLoc =  CLLocation(latitude: from_lat, longitude: from_long)
    
      // getAddress(location: addressLoc,text:newOrder.addressFrom)
    
        
    
        return newOrder
    }
    
    
    
    
}
