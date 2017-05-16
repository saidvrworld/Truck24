//
//  PubWayOnMap.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 09.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//


import Foundation
import MapKit
import CoreLocation

class PubWayOnMap: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var Distance: UILabel!
    
    var curLocation: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(AppData.fromLocation != nil && AppData.toLocation != nil){
           LoadRoad()
        }

        mapView.delegate = self
        mapView.showsUserLocation = true
        if(AppData.DriverLocation != nil){
          getDriver()
    
        }
    }
    
    
    private func getDriver(){
        
        let car = CarPlacement(coordinate: AppData.DriverLocation.coordinate,
                               title: "Машина Водителя",
                               subtitle: "Первозящего груз",id:1)
        
        var pinAnnotationView:MKPinAnnotationView!
        pinAnnotationView = MKPinAnnotationView(annotation: car, reuseIdentifier: "pin")
        
        mapView.addAnnotation(car)
    
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
        getCurrentLocation()
    }
    
    func getCenterCoordinates() {
        let center = mapView.centerCoordinate
    }
    
    
    func LoadRoad(){
    
        
        let sourceLocation = AppData.fromLocation.coordinate
        let destinationLocation = AppData.toLocation.coordinate
        
      
        let sourceAnnotation = APlacement(title: "Погрузить здесь", coordinate: sourceLocation)
        let destinationAnnotation = BPlacement(title:"Доставить Сюда", coordinate: destinationLocation)
        
        var AAnnotationView:MKPinAnnotationView!
        AAnnotationView = MKPinAnnotationView(annotation: sourceAnnotation, reuseIdentifier: "pin")

        var BAnnotationView:MKPinAnnotationView!
        BAnnotationView = MKPinAnnotationView(annotation: destinationAnnotation, reuseIdentifier: "pin")

        
        mapView.addAnnotation(sourceAnnotation)
        mapView.addAnnotation(destinationAnnotation)

        
    }
    
    
    
    func getCurrentLocation(){
        let centre = locationManager.location?.coordinate
        
        if(centre != nil){
           centerMapOnLocation(location: Loc2DToLoc(loc: centre!))
        
        
        if(AppData.waitingForLoc == "NearList"){
            AppData.currentLocation = Loc2DToLoc(loc: centre!)
        }
        else if(AppData.waitingForLoc == "FromLoc"){
            AppData.fromLocation = Loc2DToLoc(loc: centre!)
        }
        else if(AppData.waitingForLoc == "ToLoc"){
            AppData.toLocation = Loc2DToLoc(loc: centre!)
        }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    @IBAction func BackToPubDetails(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        var nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseType") as! UIViewController
        if(AppData.lastScene == "OrderDetails"){
             nextViewController = storyBoard.instantiateViewController(withIdentifier: "OrderDetails") as! OrderDetails
        }
        else if(AppData.lastScene == "PubDetails"){
             nextViewController = storyBoard.instantiateViewController(withIdentifier: "PubDetails") as! PubDetails
        }
        else if(AppData.lastScene == "AcceptedOrderInfo"){
             nextViewController = storyBoard.instantiateViewController(withIdentifier: "AcceptedOrderInfo") as! AcceptedOrderInfo
        }
        self.present(nextViewController, animated:true, completion:nil)

    }
    
    
    
    
    func Loc2DToLoc(loc:CLLocationCoordinate2D)->CLLocation{
        let getLat: CLLocationDegrees = loc.latitude
        let getLon: CLLocationDegrees = loc.longitude
        let newLoc: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        return newLoc
    }
    
    
    
    
}
