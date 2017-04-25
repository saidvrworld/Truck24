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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
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
                
        for carObj in AppData.CarList{
            let car = CarPlacement(coordinate: CLLocationCoordinate2D(latitude: carObj.latitude, longitude: carObj.longitude),
                                   title: carObj.carName,
                                   subtitle: carObj.distance+"км",id:carObj.carId)
            
            var pinAnnotationView:MKPinAnnotationView!
            pinAnnotationView = MKPinAnnotationView(annotation: car, reuseIdentifier: "pin")
            
            mapView.addAnnotation(car)
        }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
                 calloutAccessoryControlTapped control: UIControl!) {
        let car = view.annotation as! CarPlacement
        AppData.selectedCarId = car.carId
        print("selected")
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("Annotation selected")
        
        if let annotation = view.annotation as? CarPlacement {
            print("Your annotation title: \(annotation.title)");
        }
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
    
   private func GoToDetailsInfo() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CarDetails") as! CarDetails
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    
    func Loc2DToLoc(loc:CLLocationCoordinate2D)->CLLocation{
        let getLat: CLLocationDegrees = loc.latitude
        let getLon: CLLocationDegrees = loc.longitude
        let newLoc: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        return newLoc
    }
    
    
    
    
}
