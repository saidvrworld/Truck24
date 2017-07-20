//
//  AcceptedOrderInfo.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 17.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//
import Foundation
import UIKit
import MapKit
import CoreLocation

class AcceptedOrderInfo: UIViewController {
    
    @IBOutlet weak var FinishButton: UIButton!
    @IBOutlet weak var LoadingView: UIView!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var fromAddress: UILabel!
    @IBOutlet weak var toAddress: UILabel!
    @IBOutlet weak var Notes: UILabel!
    @IBOutlet weak var carTypes: UILabel!
    
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carNumber: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var carWeigth: UILabel!
    @IBOutlet weak var carType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var PhoneNumberView: UILabel!

    
    
    
    @IBOutlet weak var executionDate: UILabel!
    
    var from_long:Double!
    var from_lat:Double!
    var to_long:Double!
    var to_lat:Double!
    
    var isCarImageLoading = false
    var isRateLoading = false
    var isUserImageLoading = false
    
    var pubManager = PublicationData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppData.DriverLocation = nil
        if(AppData.lastDetailsScene == "DonePubs"){
            FinishButton.isHidden=true
        }
        GetDetails(urlstring: AppData.acceptedOrderInfoUrl, orderId: String(AppData.selectedPubId))
        
    }
    
    
    @IBAction func ShowWay(_ sender: Any) {

        AppData.lastScene = "AcceptedOrderInfo"
        NavigationManager.MoveToScene(sceneId: "PubWayOnMap", View: self)
    }
    
    
    
    @IBAction func BackToMain(_ sender: Any) {
       GoToMainView()
    }
    
    private func GoToMainView(){
        
        if(AppData.lastDetailsScene == "MainView"){
                NavigationManager.MoveToCustomerMain(View: self)
        }
        else if(AppData.lastDetailsScene == "DonePubs"){
            NavigationManager.MoveToScene(sceneId: "DonePublicatonsCustomer", View: self)
            }
    }
    
    
    func GetDetails(urlstring: String,orderId: String){
        
        let parameters = "token=fec5fdf5ac012r43"+orderId+"fec5fdf5ac012r43"
        print(urlstring)
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
           // print(responseJSON)
            if let responseJSON = responseJSON as? [String: Any] {
                DispatchQueue.main.async
                    {
                        self.InfoManager(response:responseJSON)
                }
            }
        }
        
        task.resume()
        
    }
    
    
    // Save data in Cash from response
    func InfoManager(response: [String:Any]){
        
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
               // print(dataBody)
                self.FillData(data: dataBody!)
                   
                self.LoadingView.isHidden = true
                self.pubManager.getAddress(location: AppData.fromLocation,textView: self.fromAddress)
                self.pubManager.getAddress(location: AppData.toLocation,textView: self.toAddress)
               // self.setRate(rate: Int(dataBody?["rate"] as! Double))
                self.setCarPicture(dataBody?["carPhoto"] as! String)
                self.setUserPicture(dataBody?["userPhoto"] as! String)

            }
            
        }
        
    }
    
    func FillData(data: [String:Any]){
        
        
        carTypes.text = data["carType"] as? String
        executionDate.text = data["date"] as? String
        rateLabel.text = String(data["rate"] as! Double)
        Notes.text = data["notes"] as? String
        
        carNumber.text = data["carNumber"] as? String
        details.text = data["detail"] as? String
        carWeigth.text = (data["maxWeight"] as? String)!+" тонн"
        carNumber.text = data["carNumber"] as? String
        userName.text = data["userName"] as? String
        PhoneNumberView.text = data["phoneNumber"] as? String
        price.text = (data["price"] as? String)! + " сум"
        
        from_long = data["long_from"] as! Double
        from_lat = data["lat_from"] as! Double
        to_long = data["long_to"] as! Double
        to_lat = data["lat_to"] as! Double
        

        AppData.fromLocation = CLLocation(latitude: from_lat, longitude: from_long)
        AppData.toLocation =  CLLocation(latitude: to_lat, longitude: to_long)

        do{
            let DriverLong = try data["userLong"] as? Double
            if let DriverLat = try data["userLat"] as? Double{
                let driverLocation = CLLocation.init(latitude: DriverLat, longitude:DriverLong!)
                AppData.DriverLocation = driverLocation
            }
        }
        
    }
    
   
    @IBAction func PressFinishOrder(_ sender: Any) {
        do{
           try Finish()
        }
        catch{
                 print("Error")
                 GoToMainView()
        }
    }
    
    func Finish(){
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
             self.FinishOrder()
            DispatchQueue.main.async
                {
                    self.ShowRateWindow()
            }
        }
    }
    
    
    
    private func FinishOrder(){
        let urlstring = AppData.closeOrderCustomerUrl
        var orderId = String(AppData.selectedPubId)
        
        let parameters = "token=fec5fdf5ac012r43"+orderId+"fec5fdf5ac012r43&userToken="+AppData.token
        print(urlstring)
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
            print(13)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        
        task.resume()
      
    }
    
    private func ShowRateWindow(){
        
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let PopView = storyBoard.instantiateViewController(withIdentifier: "SetDriverRateWindow") as! SetDriverRateWindow
            self.addChildViewController(PopView)
            PopView.view.frame = self.view.frame
            self.view.addSubview(PopView.view)
            PopView.didMove(toParentViewController: self)
        }
    
    
    // Setting Images
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
    
    //Downloding images
    private func DownloadCarImage(_ imgUrl:String)->UIImage{
        self.isCarImageLoading = true
        var Image: UIImage?
        let url = URL(string:imgUrl)
        let data = try? Data(contentsOf: url!)
        
            if  data!.count > 0 {
                Image = UIImage(data:data!)
            } else {
                Image = UIImage(named: "image_placeholder.png")
            }
        if(Image == nil){
            Image = UIImage(named: "image_placeholder.png")
        }
        //self.Loading.stopAnimating()
        return Image!
    }
    
    
    private func DownloadUserImage(_ imgUrl:String)->UIImage{
        self.isUserImageLoading = true
        var Image: UIImage?
        let url = URL(string:imgUrl)
        let data = try? Data(contentsOf: url!)
        
            if  data != nil{
                Image = UIImage(data:data!)
            } else {
                Image = UIImage(named: "user_icon.png")
            }
        if(Image == nil){
            Image = UIImage(named: "user_icon.png")
        }
        //self.Loading.stopAnimating()
        return Image!
    }
    
    
    // Press call Button
    @IBAction func MakeCall(_ sender: Any) {
        
        if var number = PhoneNumberView.text{
            callNumber(phoneNumber: number)
        }
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
