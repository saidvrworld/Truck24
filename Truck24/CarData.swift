//
//  CarData.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation


class CarData{
    
    
    
    func MakeRequest(urlstring: String,token:String,long: String,lat: String)->[CarShort]{
        var carList:[CarShort]!
        let parameters = "long="+long+"&lat="+lat+"&token="+token
        print(parameters)
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                carList = self.ManageResponse(response:responseJSON)
            }
        }
        
        task.resume()
        return carList
        
    }
    
    func ManageResponse(response:[String:Any])->[CarShort]{
        var carList:[CarShort] = []

        if let array = response["data"] as? [Any] {

            for carObj in array {
                let dataBody = carObj as? [String: Any]
                
                carList.append(ParseCar(dataBody! as [String : AnyObject]))
                
            }
        }
        return carList
        
    }

    
    
    
    func ParseCar(_ car:[String:AnyObject])->CarShort{
        let newCar = CarShort()
        newCar.carId = car["carId"] as! Int
        newCar.carImageUrl = car["carImageUrl"] as! String
        newCar.carName = car["carName"] as! String
        newCar.distance = car["distance"] as! Float
        newCar.rate = car["rate"] as! Double

        return newCar
    }
    
}
