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
    
    
    
    //Заказы для водителя подходящие для его типа машины 
    //аддресс дата детали
     func GetOrderList(table: OrderListForDriver,urlAddress: String,token:String){
        
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
                    AppData.OrderForDriverList = self.GetOrderResponse(response:responseJSON)
                    DispatchQueue.main.async
                        {
                            
                            if(AppData.OrderForDriverList.count != 0){
                                table.tableView.reloadData()
                            }
                            else{
                                table.EmptyView.isHidden = false
                            }
                    }
                }
                
            }
        }
        
        task.resume()
        
    }
    
    // ответ для GetOrderList получакет ответ на  запрос и отправляет обьект json order в функцию ParseOrder
    private func GetOrderResponse(response:[String:Any])->[OrderForDriver]{
        var orderList:[OrderForDriver] = []
        
        if let array = response["data"] as? [Any] {
            
            for orderObj in array {
                let dataBody = orderObj as? [String: Any]
                orderList.append(ParseOrder(dataBody! as [String : AnyObject]))
                
            }
        }
        return orderList
        
    }
    
    
    // Определяет адрес по координатам
    func getAddress(location: CLLocation,order:OrderForDriver){
        var fullAddress:String = " "
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                //print(locationName)
                fullAddress = (locationName as String)
                DispatchQueue.main.async{
                    order.addressFrom = fullAddress
                }
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

        var addressLoc =  CLLocation(latitude: from_lat, longitude: from_long)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
        DispatchQueue.main.async
            {
                self.getAddress(location: addressLoc,order:newOrder)

            }
        }
        return newOrder
    }
    
    func GetMyOrderList(table: UITableView,urlAddress: String,token:String){
        
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
                    AppData.MyOrderForDriverList = self.GetMyOrderResponse(response:responseJSON)
                    DispatchQueue.main.async
                        {
                            table.reloadData()
                    }
                }

            }
        }
        task.resume()
    }
    
    
    private func GetMyOrderResponse(response:[String:Any])->[MyOrderForDriver]{
        var orderList:[MyOrderForDriver] = []
        
        if let array = response["data"] as? [Any] {
            
            for orderObj in array {
                let dataBody = orderObj as? [String: Any]
                
                let newOrder = MyOrderForDriver()
                newOrder.orderId = dataBody?["orderId"] as! Int
                newOrder.userName = dataBody?["userName"] as! String
                newOrder.date_of_execution = dataBody?["date"] as! String
                orderList.append(newOrder)

            }
        }
        return orderList
    }
    
    
    
}
