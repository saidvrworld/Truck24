//
//  OfferDetails.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 10.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//
import Foundation

import UIKit



class OfferDetails: UIViewController {
    
    
    @IBOutlet weak var LoadingIndicator: UIView!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carNumber: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var carWeigth: UILabel!
    @IBOutlet weak var carType: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var PhoneNumberView: UILabel!
    
    var StarList:[UIImageView]!
    
    
    var isCarImageLoading = false
    var isUserImageLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        GetData(urlstring: AppData.getOfferInfoUrl, offerId: String(AppData.selectedOfferId))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MakeCall(_ sender: Any) {
        
        if let number = PhoneNumberView.text{
            callNumber(phoneNumber: number)
        }
    }
    
    private func GetData(urlstring: String,offerId: String){
        
        let parameters = "token=fec5fdf5ac012r43"+offerId+"fec5fdf5ac012r43"
        
        print(parameters)
        
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                NavigationManager.ShowError(errorText: "Ошибка Соединения!",View: self)
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                self.InfoManager(response:responseJSON)
            }
        }
        
        task.resume()
        
    }
    
    private func InfoManager(response: [String:Any]){
        
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                
                    DispatchQueue.main.async
                        {
                            self.SetText(data: dataBody!)

                            self.LoadingIndicator.isHidden = true
                    }
                
                setCarPicture(dataBody?["carImageUrl"] as! String)
                setUserPicture(dataBody?["userPhoto"] as! String)
                
                
            }
            
        }
        
    }
    
    private func SendAcceptOffer(urlstring: String,offerId: String){
        
        let parameters = "token=fec5fdf5ac012r43"+offerId+"fec5fdf5ac012r43"
        
        print(parameters+urlstring)
        
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                NavigationManager.ShowError(errorText: "Ошибка Соединения!",View: self)

                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                if let array = responseJSON["data"] as? [Any] {
                    if let firstObject = array.first {
                                                                                    DispatchQueue.main.async
                                    {
                                      NavigationManager.MoveToCustomerMain(View: self)
                                     }
                            
                        
                    }
                    
                }
            }
        }
        
        task.resume()
        
    }
    
    
    
    private func SetText(data:[String:Any]){
        
        userName.text = data["userName"] as? String
        carNumber.text = data["carNumber"] as? String
        carWeigth.text = (data["carMaxWeight"] as! String)+" тонн"
        carType.text = data["carName"] as? String
        details.text = data["detail"] as? String
        price.text = (data["price"] as! String) + " сум"
        PhoneNumberView.text = data["phoneNumber"] as? String
        rateLabel.text = String(data["rate"] as! Double)

        
    }
    
    
    @IBAction func BackToMainView(_ sender: Any) {
        
        self.GoToMainView()
    }
    
   private func GoToMainView(){
    NavigationManager.MoveToScene(sceneId: "OffersList", View: self)
    }
    
    private func setCarPicture(_ url:String){
        if(self.isCarImageLoading){
            //self.Loading.startAnimating()
        }
        if(!isCarImageLoading){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                self.carImage.image =  self.DownloadCarImage(url)
                DispatchQueue.main.async
                    {
                        self.isCarImageLoading = false
                }
                
            }
        }
        
    }
    
    
    private func DownloadCarImage(_ imgUrl:String)->UIImage{
        self.isCarImageLoading = true
        var Image: UIImage?
        let url = URL(string:imgUrl)
        let data = try? Data(contentsOf: url!)
        if data != nil {
            Image = UIImage(data:data!)
        } else {
            Image = UIImage(named: "placeholder.jpg")
        }
        if(Image == nil){
            Image = UIImage(named: "placeholder.jpg")
            
        }
        return Image!
    }
    
    private func setUserPicture(_ url:String){
        if(self.isUserImageLoading){
            //self.Loading.startAnimating()
        }
        if(!isUserImageLoading){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                self.userImage.image =  self.DownloadUserImage(url)
                DispatchQueue.main.async
                    {
                        self.isUserImageLoading = false
                }
                
            }
        }
        
    }
    

    @IBAction func AcceptPrice(_ sender: Any) {
        self.SendAcceptOffer(urlstring: AppData.acceptOfferUrl, offerId: String(AppData.selectedOfferId))
    }
    
    private func DownloadUserImage(_ imgUrl:String)->UIImage{
        self.isUserImageLoading = true
        var Image: UIImage?
        let url = URL(string:imgUrl)
        let data = try? Data(contentsOf: url!)
        
            if data != nil {
                Image = UIImage(data:data!)
            } else {
                Image = UIImage(named: "user_icon.png")
            }
        if(Image == nil){
            Image = UIImage(named: "user_icon.png")
            
        }
        return Image!
    }
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                application.openURL(phoneCallURL as URL);
            }
        }
    }
    
    
}
