//
//  CarPlacement.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation

import MapKit
import AddressBook


class CarPlacement: NSObject, MKAnnotation {
    
    let Title: String
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.Title = title
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
        mapItem.name = Title
        
        return mapItem
    }
    
}
