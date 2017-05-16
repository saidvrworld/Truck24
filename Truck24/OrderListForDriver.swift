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
    private let orderMananger = OrderForDriverData()
    var locManager = SendLocation()
    
    @IBOutlet weak var LocationButton: UISwitch!
    
    @IBAction func SwitchedLocation(_ sender: UISwitch) {
        if(sender.isOn){
            locManager.SendLocation(status: "true")
            ShowError(errorType: "LocationOn")
        }
        else{
            locManager.SendLocation(status: "false")
            ShowError(errorType: "LocationOff")
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        orderMananger.GetOrderList(table: self,urlAddress: AppData.getOrdersForDriverUrl, token: AppData.token)
        super.viewDidLoad()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
        GoToDetailsInfo()
    }
    
    
    @IBAction func GoToSetCoordinate(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NearCarMap") as! NearCarMap
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    func GoToDetailsInfo() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OrderDetails") as! OrderDetails
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    private func ShowError(errorType: String){
        
        if(errorType=="LocationOn"){
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let PopView = storyBoard.instantiateViewController(withIdentifier: "LocationOn") as! PopUpViewController
            self.addChildViewController(PopView)
            PopView.view.frame = self.view.frame
            self.view.addSubview(PopView.view)
            PopView.didMove(toParentViewController: self)
        }
    }
    
}
