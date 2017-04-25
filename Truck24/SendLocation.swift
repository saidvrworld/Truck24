//
//  SendLocation.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 15.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import CoreLocation

class SendLocation{
    let LocationUrl = "http://track24.beetechno.uz/api/driver/location/"
  
    var locationManager = CLLocationManager()

    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            
        } else {
            locationManager.requestAlwaysAuthorization()
            
        }
    }
    
    func GetCurrentLocation()-> CLLocationCoordinate2D{
        let centre = locationManager.location?.coordinate
        return centre!
    }
    
    func SendLocation(){
        var curLocation = GetCurrentLocation()
        var curLong = String(curLocation.longitude.binade)
        var curLat = String(curLocation.latitude.binade)
        var user_id = "12"
        var user_status = "1"
        MakeRequest(urlstring: LocationUrl, userId: AppData.token, lat: curLat, long: curLong, status: user_status)
    
    }
    
    private func MakeRequest(urlstring: String,userId: String,lat: String,long: String,status: String){
        
        let parameters = "lat="+lat+"&long="+long+"&status="+status+"&token="+userId
        
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
                print("Location sended")
            }
        }
        
        task.resume()
        
    }
    
    
    

}
