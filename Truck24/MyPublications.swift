//
//  MyPublications.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation



import UIKit

class MyPublications: UIViewController{
    
    
    let pubMananger =  PublicationData()
    
    @IBOutlet weak var tableView: UITableView!
    
    
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
    
    
    @IBAction func AddPublication(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddPublication") as! AddPublication
        self.present(nextViewController, animated:true, completion:nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AppData.PubList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> PubCell {
        let tableRow:PubCell = self.tableView.dequeueReusableCell(withIdentifier: "PubCell",for: indexPath) as! PubCell
        tableRow.createCell(pub: AppData.PubList[indexPath.row])
        return tableRow
        
    }
    
    
     func UpdateTable(){
        pubMananger.GetMyPub(table: self,urlAddress: AppData.getPublicationsUrl, token: AppData.token)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = tableView.cellForRow(at: indexPath!) as! PubCell
        AppData.selectedPubId = currentCell.pubId
        if(currentCell.status == 0){
            GoToDetailsInfo()
        }
        else if(currentCell.status == 1){
            AppData.lastDetailsScene = "MainView"
            GoToAcceptedDetailsInfo()
        }
    }
    
    
    func GoToDetailsInfo() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PubDetails") as! PubDetails
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func GoToAcceptedDetailsInfo() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AcceptedOrderInfo") as! AcceptedOrderInfo
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
     func ShowErrorConnection(){
        
        
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let PopView = storyBoard.instantiateViewController(withIdentifier: "badConnection") as! PopUpViewController
            self.addChildViewController(PopView)
            PopView.view.frame = self.view.frame
            self.view.addSubview(PopView.view)
            PopView.didMove(toParentViewController: self)
        
      }
    
}
