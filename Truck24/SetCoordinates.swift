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
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(longPressGesture)
        
        //let initialLocation = CLLocation(latitude: 41.354007, longitude: 69.289989)
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
        
        let car = CarPlacement(title: "Kamaz",
                               locationName: "Крытый вверх",
                               coordinate: CLLocationCoordinate2D(latitude: curLocation.coordinate.latitude, longitude: curLocation.coordinate.longitude))
        
        mapView.addAnnotation(car)
        
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
    
    func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .ended {
            let point = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            print(coordinate)
            
            let getLat: CLLocationDegrees = coordinate.latitude
            var getLon: CLLocationDegrees = coordinate.longitude
            var newLoc: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
            AppData.currentLocation = newLoc
            
            var annotation = MyPlacement(locationName: "Yunus", coordinate: coordinate)

            self.mapView.addAnnotation(annotation)
        }
    }
    
    
    
    
    
}
