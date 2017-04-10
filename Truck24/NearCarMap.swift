//
//  NearCarMap.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 09.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//


import Foundation
import MapKit
import CoreLocation

class NearCarMap: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var Distance: UILabel!
    
    var curLocation: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
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
        AppData.currentLocation = Loc2DToLoc(loc: (locationManager.location?.coordinate)!)
         centerMapOnLocation(location: AppData.currentLocation)
        LoadCars()

    }
    
    func getCenterCoordinates() {
        let center = mapView.centerCoordinate
    }
    
    
    func LoadCars(){
        var initialLocation = CLLocation(latitude: 41.354007, longitude: 69.289989)
        //centerMapOnLocation(location: initialLocation)
        initialLocation = AppData.currentLocation
         let car = CarPlacement(title: "Kamaz",
                             locationName: "Крытый вверх",
                           coordinate: CLLocationCoordinate2D(latitude: initialLocation.coordinate.latitude+0.000003, longitude: initialLocation.coordinate.longitude+0.000003))
        let car2 = CarPlacement(title: "Kamaz",
                               locationName: "Крытый вверх",
                               coordinate: CLLocationCoordinate2D(latitude: initialLocation.coordinate.latitude+0.000007, longitude: initialLocation.coordinate.longitude+0.000007))
        
         mapView.addAnnotation(car)
        mapView.addAnnotation(car2)

        
    }
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLocationAuthorizationStatus()
        
    }
    
    @IBAction func BackToMainView(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    
    
    
    func Loc2DToLoc(loc:CLLocationCoordinate2D)->CLLocation{
        let getLat: CLLocationDegrees = loc.latitude
        let getLon: CLLocationDegrees = loc.longitude
        let newLoc: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        return newLoc
    }
    
    
    
    
}
