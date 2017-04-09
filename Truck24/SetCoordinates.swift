//
//  SetCoordinates.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class SetCoordinates: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var curLocation: CLLocation!


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: 41.354007, longitude: 69.289989)
       // centerMapOnLocation(location: initialLocation)
        let car = CarPlacement(title: "Kamaz",
                              locationName: "Крытый вверх",
                              coordinate: CLLocationCoordinate2D(latitude: 41.353516, longitude: 69.289002))
        
       // mapView.addAnnotation(car)
        mapView.delegate = self 

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    var locationManager = CLLocationManager()
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
            
        }
        getCurrentLocation()
    }
    
    func getCenterCoordinates() {
        var center = mapView.centerCoordinate
    }
    
    func getCurrentLocation(){
        var centre = locationManager.location?.coordinate
        let getLat: CLLocationDegrees = centre!.latitude
        var getLon: CLLocationDegrees = centre!.longitude
        var newLoc: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        centerMapOnLocation(location: newLoc)
        curLocation = newLoc
        AppData.currentLocation = curLocation
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    @IBAction func BackToSignIn(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
            self.present(nextViewController, animated:true, completion:nil)
       
    }
    
    
    
}
