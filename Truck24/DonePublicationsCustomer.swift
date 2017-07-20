//
//  DonePublicationsCustomer.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 04.05.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import Foundation



import UIKit

class DonePublicatonsCustomer: MyPublications{
        
    override func viewDidLoad() {
        UpdateTable()
        super.viewDidLoad()
       StartTimer()

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func ShowLoadingView(show:Bool){
        DispatchQueue.main.async
            {
                self.LoadingView.isHidden = !show
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.ShowLoadingView(show: false)
        return AppData.DonePubList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> PubCell {
        let tableRow:PubCell = tableView.dequeueReusableCell(withIdentifier: "DonePubCell",for: indexPath) as! PubCell
        tableRow.createCell(pub: AppData.DonePubList[indexPath.row])
        return tableRow
        
    }
    
      override func UpdateTable(){
        self.ShowLoadingView(show: true)
        pubMananger.GetDonePub(table: self,urlAddress: AppData.getFinishedPublicationsUrl, token: AppData.token)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = tableView.cellForRow(at: indexPath!) as! PubCell
        AppData.selectedPubId = currentCell.pubId
        AppData.lastDetailsScene = "DonePubs"
        NavigationManager.MoveToScene(sceneId: "AcceptedOrderInfo", View: self)
        
    }
    
    @IBAction func Back(_ sender: Any) {
        NavigationManager.MoveToCustomerMain(View: self)
    }
    
    
}
