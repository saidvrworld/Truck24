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
    @IBOutlet weak var LoadingView: UIView!

    
    override func viewDidLoad() {
        UpdateTable()
        super.viewDidLoad()
        StartTimer()
    }
    
    func StartTimer(){
        var timer = Timer.scheduledTimer(timeInterval: AppData.UpdateInterval, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        NavigationManager.TimerList.append(timer)
        
    }
    
    @objc func update() {
        UpdateTable()
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
    
    
    @IBAction func AddPublication(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "AddPublication", View: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.ShowLoadingView(show: false)
        return AppData.PubList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> PubCell {
        let tableRow:PubCell = self.tableView.dequeueReusableCell(withIdentifier: "PubCell",for: indexPath) as! PubCell
        tableRow.createCell(pub: AppData.PubList[indexPath.row])
        return tableRow
        
    }
    
    
     func UpdateTable(){
        self.ShowLoadingView(show: true)
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
        NavigationManager.MoveToScene(sceneId: "PubDetails", View: self)
    }
    
    func GoToAcceptedDetailsInfo() {
        NavigationManager.MoveToScene(sceneId: "AcceptedOrderInfo", View: self)
    }
    
    
}
