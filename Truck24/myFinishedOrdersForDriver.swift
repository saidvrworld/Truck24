//
//  myFinishedOrdersForDriver.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 25.05.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit

class MyFinishedOrdersListForDriver: UIViewController{
    
    
    private let orderMananger = OrderForDriverData()
    
    @IBOutlet weak var LoadingView: UIView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        orderMananger.GetMyOrderList(table: tableView,urlAddress: AppData.getMyFinishedOrdersForDriverUrl, token: AppData.token)
        super.viewDidLoad()
        StartTimer()
    }
    
    func StartTimer(){
        var timer = Timer.scheduledTimer(timeInterval: AppData.UpdateInterval, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        NavigationManager.TimerList.append(timer)
        
    }
    
    @objc func update() {
        self.ShowLoadingView(show: true)
        orderMananger.GetMyOrderList(table: tableView,urlAddress: AppData.getMyFinishedOrdersForDriverUrl, token: AppData.token)
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
        return AppData.MyOrderForDriverList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> MyOrderForDriverCell {
        let tableRow:MyOrderForDriverCell = self.tableView.dequeueReusableCell(withIdentifier: "MyOrderForDriverCell",for: indexPath) as! MyOrderForDriverCell
        tableRow.createCell(order: AppData.MyOrderForDriverList[indexPath.row])
        return tableRow
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! MyOrderForDriverCell
        AppData.selectedOrderForDriverId = currentCell.orderId
        AppData.lastDetailsScene = "MyFinishedOrderForDriver"
        GoToDetailsInfo()
    }
    
    @IBAction func BackToMainMenu(_ sender: Any) {
        NavigationManager.MoveToDriverMain(View: self)
    }
    
    
    func GoToDetailsInfo() {
        NavigationManager.MoveToScene(sceneId: "OrderDetails", View: self)
    }
    
}
