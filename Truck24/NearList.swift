//
//  NearList.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 07.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation


import UIKit
import MapKit
import CoreLocation

class NearList: UIViewController{
    
    var locationManager = CLLocationManager()
    @IBOutlet weak var LoadingView: UIView!

    let carMananger = CarData()
    
    @IBOutlet weak var EmptyListView: UIView!
    
    @IBAction func GoToCarFilter(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "CarFilter", View: self)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        if(AppData.CarList.count == 0){
            UpdateCarTable()
        }
        super.viewDidLoad()
        StartTimer()

    }
    
    func StartTimer(){
        var timer = Timer.scheduledTimer(timeInterval: AppData.UpdateInterval, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        NavigationManager.TimerList.append(timer)
        
    }

    
    @objc func update() {
        UpdateCarTable()
    }
    
    func ShowLoadingView(show:Bool){
        DispatchQueue.main.async
            {
                self.LoadingView.isHidden = !show
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.ShowLoadingView(show: false)
        return AppData.CarList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> CarCell {
        let tableRow:CarCell = self.tableView.dequeueReusableCell(withIdentifier: "CarCell",for: indexPath) as! CarCell
        tableRow.createCell(car: AppData.CarList[indexPath.row])
        return tableRow
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = tableView.cellForRow(at: indexPath!) as! CarCell
        AppData.selectedCarId = currentCell.carId
        GoToDetailsInfo()
    }
    
    private func UpdateCarTable(){
        self.ShowLoadingView(show: true)
        var my_location:CLLocationCoordinate2D!
        if(AppData.currentLocation == nil){
             my_location = locationManager.location?.coordinate
        }
        else{
             my_location = AppData.currentLocation.coordinate
        }
        if(AppData.carTypeID == nil){
            carMananger.MakeRequest(table: self,urlAddress: AppData.nearListUrl, token: AppData.token, long: String(describing: my_location?.longitude.binade), lat: String( describing: my_location?.latitude.binade),carTypeId: "None")
        }
        else{
        carMananger.MakeRequest(table: self,urlAddress: AppData.nearFilteredListUrl, token: AppData.token, long: String(describing: my_location?.longitude.binade), lat: String( describing: my_location?.latitude.binade),carTypeId: AppData.carTypeID)
        }
    }
    
    @IBAction func GoToCarMap(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "NearCarMap", View: self)
    }
    
    func GoToDetailsInfo() {
        NavigationManager.MoveToScene(sceneId: "CarDetails", View: self)
    }
    
    
    
    func HideEmptyError(){
       self.EmptyListView.isHidden = true
    
    }
    
    func ShowEmptyError(){
        self.EmptyListView.isHidden = false
        
    }
    
}
