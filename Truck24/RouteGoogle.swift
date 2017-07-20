//
//  RouteGoogle.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 25.05.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import GoogleMaps

class RouteMap: UIViewController {
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    var selectedRoute: Dictionary<NSObject, AnyObject>!
    var overviewPolyline: Dictionary<NSObject, AnyObject>!
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    var originAddress: String!
    var destinationAddress: String!
    var curLocation: CLLocation!
    
    var locationManager = CLLocationManager()
    
    @IBAction func PressBack(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: AppData.lastScene, View: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createMap()

        if(AppData.fromLocation != nil && AppData.toLocation != nil){
           getData(urlstring: AppData.GoogleDirectionsAPIUrl,fromPoint: AppData.fromLocation,toPoint: AppData.toLocation)
            CreateMarkers()
        }
        
        if(AppData.DriverLocation != nil){
          getDriver()
            
        }
        
        
    }
    
     func createMap() {
        
        let myLocation = locationManager.location?.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: (myLocation?.latitude)!,longitude: (myLocation?.longitude)!,zoom: 15)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        view = mapView
    }
    
    private func getDriver(){
        let marker = GMSMarker()
        marker.position = AppData.DriverLocation.coordinate
        marker.icon = UIImage(named: "trackLocation.png")
        marker.title = "Ваш Водитель"
        marker.snippet = "Перевозчик"
        marker.map = view as? GMSMapView

    }
    
    private func getData(urlstring: String,fromPoint:CLLocation,toPoint:CLLocation){
        
    
        let destLatitude=toPoint.coordinate.latitude
        let destLongitude=toPoint.coordinate.longitude
        let originalLatitude=fromPoint.coordinate.latitude
        let originalLongitude=fromPoint.coordinate.longitude
        
        
        let key = AppData.GoogleDirectionsAPIKey
        let parameters = "origin="+String(originalLatitude)+","+String(originalLongitude)+"&destination="+String(destLatitude)+","+String(destLongitude)+"&key="+key
        var finalUrl = urlstring+"?"+parameters
        
        print(finalUrl)

        let url = URL(string:finalUrl)
        let data = try? Data(contentsOf: url!)
        
        let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
        if let responseJSON = responseJSON as? [String: Any] {
            self.InfoManager(response:responseJSON)
        }

        
    }
    
    func CreateMarkers(){
        
        
        let FromMarker = GMSMarker()
        FromMarker.position = AppData.fromLocation.coordinate
        FromMarker.appearAnimation = kGMSMarkerAnimationPop
        FromMarker.icon = UIImage(named: "A.png")
        FromMarker.map = view as? GMSMapView
        
        let ToMarker = GMSMarker()
        ToMarker.position = AppData.toLocation.coordinate
        ToMarker.appearAnimation = kGMSMarkerAnimationPop
        ToMarker.icon = UIImage(named: "B.png")
        ToMarker.map = view as? GMSMapView
    
    }
    
    
    var wayPoints:[CLLocationCoordinate2D] = []
    
    private func InfoManager(response: [String:Any]){
        print(response)
        if let array = response["routes"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                
                let legs = dataBody?["legs"] as? [Any]
                if let firstLeg = legs?.first {
                    let leg = firstLeg as? [String: Any]
                    let steps = leg?["steps"] as? [Any]
                    for step in steps!{
                        let stepData = step as? [String: Any]
                        let startLocation = stepData?["start_location"] as? [String: Any]
                        let fromLong = startLocation?["lng"] as? Double
                        let fromLat = startLocation?["lat"] as? Double
                        wayPoints.append(CLLocationCoordinate2D(latitude: fromLat!, longitude: fromLong!))
                        
                        let endLocation = stepData?["end_location"] as? [String: Any]
                        let toLong = endLocation?["lng"] as? Double
                        let toLat = endLocation?["lat"] as? Double
                        wayPoints.append(CLLocationCoordinate2D(latitude: toLat!, longitude: toLong!))
                    
                    }
                    CreateRoute()
                
                }
            }
            
        }
        
    }
    
    func CreateRoute(){
      let path = GMSMutablePath()
        
        for point in wayPoints{
            path.add(point)
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .red
        polyline.strokeWidth = 5.0
        polyline.map = view as? GMSMapView
    }
    
    
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {

        } else {
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    func Loc2DToLoc(loc:CLLocationCoordinate2D)->CLLocation{
        let getLat: CLLocationDegrees = loc.latitude
        let getLon: CLLocationDegrees = loc.longitude
        let newLoc: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        return newLoc
    }
    
}
