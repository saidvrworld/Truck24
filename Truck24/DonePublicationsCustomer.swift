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
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AppData.DonePubList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> PubCell {
        let tableRow:PubCell = tableView.dequeueReusableCell(withIdentifier: "DonePubCell",for: indexPath) as! PubCell
        tableRow.createCell(pub: AppData.DonePubList[indexPath.row])
        return tableRow
        
    }
    
      override func UpdateTable(){
        pubMananger.GetDonePub(table: self,urlAddress: AppData.getFinishedPublicationsUrl, token: AppData.token)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = tableView.cellForRow(at: indexPath!) as! PubCell
        AppData.selectedPubId = currentCell.pubId
        AppData.lastDetailsScene = "DonePubs"
        GoToAcceptedDetailsInfo()
        
    }
    
    @IBAction func Back(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
}
