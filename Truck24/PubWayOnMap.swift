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

        
        //let initialLocation = CLLocation(latitude: 41.354007, longitude: 69.289989)
        // centerMapOnLocation(location: initialLocation)
        
        // let car = CarPlacement(title: "Kamaz",
        //                     locationName: "Крытый вверх",
        //                   coordinate: CLLocationCoordinate2D(latitude: 41.353516, longitude: 69.289002))
        
        // mapView.addAnnotation(car)
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
        getCurrentLocation()
    }
    
    func getCenterCoordinates() {
        let center = mapView.centerCoordinate
    }
    
    
    func LoadRoad(){
    
        
        let sourceLocation = AppData.fromLocation.coordinate
        let destinationLocation = AppData.toLocation.coordinate
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Погрузить здесь"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Доставить Сюда"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        print("1")
        // 8.
        directions.calculate {
            (response, error) -> Void in
            print("1.1")

            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                print("1.2")
               
               return
            }
            print("1.3")

            let route = response.routes[0]
            print("1.4")

            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            print("1.5")

            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            self.Distance.text =  String(route.distance/1000)+" км"
            
            
        }
    }
    
    
    
    func getCurrentLocation(){
        let centre = locationManager.location?.coordinate
        
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
