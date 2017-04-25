//
//  myOrdersForDriver.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 15.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation


import Foundation



import UIKit

class MyOrdersListForDriver: UIViewController{
    
    
    private let orderMananger = OrderForDriverData()
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        orderMananger.GetMyOrderList(table: tableView,urlAddress: AppData.getMyOrdersForDriverUrl, token: AppData.token)
        super.viewDidLoad()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
        GoToDetailsInfo()
    }
    
    
    
    func GoToDetailsInfo() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OrderDetails") as! OrderDetails
        self.present(nextViewController, animated:true, completion:nil)
    }
    
}
