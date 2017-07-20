//
//  OrderListForDriver.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 10.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit

class OrderListForDriver: UIViewController{
    
    
    @IBOutlet weak var EmptyView: UIView!
    @IBOutlet weak var LoadingView: UIView!

    private let orderMananger = OrderForDriverData()
    var locManager = SendLocation()
    
    @IBOutlet weak var LocationButton: UISwitch!
    
    @IBAction func SwitchedLocation(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        if(sender.isOn){
            NavigationManager.ShowError(errorText: "геолокация включена",View: self)
            AppData.SendStatus = "true"
            defaults.set(AppData.SendStatus, forKey: localKeys.sendStatus)
        }
        else{
            NavigationManager.ShowError(errorText: "геолокация отключена",View: self)
            AppData.SendStatus = "false"
            defaults.set(AppData.SendStatus, forKey: localKeys.sendStatus)
            
        }

    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        orderMananger.GetOrderList(table: self,urlAddress: AppData.getOrdersForDriverUrl, token: AppData.token)
        super.viewDidLoad()
        LoadScene()

    }
    
    func LoadScene(){
        StartTimer()
        
        locManager.StartTimer()
        if(AppData.SendStatus == "true"){
            self.LocationButton.setOn(true, animated: false)
        }
        else{
            self.LocationButton.setOn(false, animated: false)
        }
    
    }
    
    func StartTimer(){
        var timer = Timer.scheduledTimer(timeInterval: AppData.UpdateInterval, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        NavigationManager.TimerList.append(timer)
        
    }
    
    @objc func update() {
        self.ShowLoadingView(show: true)
        orderMananger.GetOrderList(table: self,urlAddress: AppData.getOrdersForDriverUrl, token: AppData.token)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func ShowLoadingView(show:Bool){
        DispatchQueue.main.async
            {
                self.LoadingView.isHidden = !show
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.ShowLoadingView(show: false)
        return AppData.OrderForDriverList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> OrderForDriverCell {
        let tableRow:OrderForDriverCell = self.tableView.dequeueReusableCell(withIdentifier: "OrderForDriverCell",for: indexPath) as! OrderForDriverCell
        tableRow.createCell(order: AppData.OrderForDriverList[indexPath.row])
        return tableRow
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! OrderForDriverCell
        AppData.selectedOrderForDriverId = currentCell.orderId
        AppData.lastDetailsScene = "MainView"
        NavigationManager.MoveToScene(sceneId: "OrderDetails",View: self)
    }
    
    
}
