//
//  OffersList.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 09.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation


import UIKit

class OffersList: UIViewController{
    
    var offerList:[Offer] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetOffers(table: tableView, urlAddress: AppData.getOffersUrl, id: String(AppData.selectedPubId))
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func GetOffers(table: UITableView,urlAddress: String,id:String){
        
        let parameters = "token=fec5fdf5ac012r43"+id+"fec5fdf5ac012r43"
        
        print(parameters)
        let url = URL(string: urlAddress)
        var request = URLRequest(url: (url)!)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {

                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    self.offerList = self.GetOfferResponse(response:responseJSON)
                    DispatchQueue.main.async
                        {
                            table.reloadData()
                    }
                }
                
            }
        }
        
        task.resume()
        
    }

    func GetOfferResponse(response:[String:Any])->[Offer]{
        var offersList:[Offer] = []
        
        if let array = response["data"] as? [Any] {
            
            for pubObj in array {
                let dataBody = pubObj as? [String: Any]
                print(dataBody)
                
                offersList.append(ParseOffer(dataBody! as [String : AnyObject]))
                
            }
        }
        return offersList
        
    }
    
    func ParseOffer(_ pub:[String:AnyObject])->Offer{
        let newOffer = Offer()
        newOffer.offerId = pub["offerId"] as! Int
        newOffer.offerName = pub["offerName"] as! String
        newOffer.offerPrice = pub["offerPrice"] as! String
       
        return newOffer
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return offerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> OfferCell {
        let tableRow:OfferCell = self.tableView.dequeueReusableCell(withIdentifier: "OfferCell",for: indexPath) as! OfferCell
        tableRow.createCell(offer: offerList[indexPath.row])
        return tableRow
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = tableView.cellForRow(at: indexPath!) as! OfferCell
        AppData.selectedOfferId = currentCell.offerId
        GoToOfferInfo()
    }
    
    @IBAction func Back(_ sender: Any) {
        GoToDetailsInfo()
    }
    
    func GoToOfferInfo() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OfferDetails") as! OfferDetails
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func GoToDetailsInfo() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PubDetails") as! PubDetails
        self.present(nextViewController, animated:true, completion:nil)
    }
    
}
