//
//  CarPlacement.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AddressBook


class CarPlacement: NSObject, MKAnnotation {
    
    let CarType: String
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    var imageName: UIImage = UIImage(named: "trackLocation.png")!

    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.CarType = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subTitle: String {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subTitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = CarType
        
        return mapItem
    }
    
}


class MyPlacement: NSObject, MKAnnotation {
    
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    var imageName: UIImage = UIImage(named: "myLocation.png")!


    init(locationName: String, coordinate: CLLocationCoordinate2D) {
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subTitle: String {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subTitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationName
        
        return mapItem
    }
    
}

class Placement: NSObject, MKAnnotation {
    
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    var imageName: UIImage = UIImage(named: "placeLocation.png")!
    
    
    init(locationName: String, coordinate: CLLocationCoordinate2D) {
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subTitle: String {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subTitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationName
        
        return mapItem
    }
    
}
