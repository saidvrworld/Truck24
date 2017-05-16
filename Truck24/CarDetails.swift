//
//  CarDetails.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation

import UIKit



class CarDetails: UIViewController {
    
    
    @IBOutlet weak var ErrorView: UIView!
    @IBOutlet weak var LoadingIndicator: UIView!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carNumber: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var carWeigth: UILabel!
    @IBOutlet weak var carType: UILabel!
    
    @IBOutlet weak var Star5: UIImageView!
    @IBOutlet weak var Star4: UIImageView!
    @IBOutlet weak var PhoneNumberView: UILabel!
    @IBOutlet weak var Star3: UIImageView!
    @IBOutlet weak var Star2: UIImageView!
    @IBOutlet weak var Star1: UIImageView!
    
    var StarList:[UIImageView]!

    
    var isCarImageLoading = false
    var isUserImageLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StarList = [Star1,Star2,Star3,Star4,Star5]
        if(AppData.CarDetailsList[AppData.selectedCarId] != nil){
              DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                self.FillDataFromAppData()
                DispatchQueue.main.async
                    {
                        self.LoadingIndicator.isHidden = true
                }
                
              }
              setCarPicture((AppData.CarDetailsList[AppData.selectedCarId]?.carImage)!)
              setUserPicture((AppData.CarDetailsList[AppData.selectedCarId]?.userImage)!)
              setRate(rate: Int((AppData.CarDetailsList[AppData.selectedCarId]?.rate)!))

         }
        else{
          MakeRequest(urlstring: AppData.CarInfoUrl, carId: String(AppData.selectedCarId))
        }

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MakeCall(_ sender: Any) {
        
        if var number = PhoneNumberView.text{
            callNumber(phoneNumber: number)
        }
    }
    
    private func MakeRequest(urlstring: String,carId: String){
        
        let parameters = "token=fec5fdf5ac012r43"+carId+"fec5fdf5ac012r43"
        
        print(parameters)
        
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async
                        {
                            self.ErrorView.isHidden = false
                            self.ShowErrorConnection()
                    }
                }
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
                print(dataBody)
                AppData.CarDetailsList[AppData.selectedCarId] = CarDetail()
                self.FillTextData(car: dataBody!)
                setCarPicture(dataBody?["carImageUrl"] as! String)
                setUserPicture(dataBody?["userPhoto"] as! String)
                
                let carRate = dataBody?["rate"] as! Double
                let carIntRate = Int(carRate)
                self.setRate(rate: carIntRate)

            }
            
        }
        
    }
    
    
    private func FillTextData(car: [String:Any]){
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
            self.SetText(data: car)
            DispatchQueue.main.async
                {
                    self.FillDataFromAppData()
            }
            
        }
    }
    
    private func SetText(data:[String:Any]){
        var CurrenrCarDetails = AppData.CarDetailsList[AppData.selectedCarId]
        CurrenrCarDetails?.userName = data["userName"] as! String
        CurrenrCarDetails?.carNumber = data["carNumber"] as! String
        CurrenrCarDetails?.carWeigth = data["carMaxWeight"] as! String
        CurrenrCarDetails?.carType = data["carName"] as! String
        CurrenrCarDetails?.details = data["detail"] as! String
        CurrenrCarDetails?.phoneNumber = data["phoneNumber"] as! String
        CurrenrCarDetails?.carImage = data["carImageUrl"] as! String
        CurrenrCarDetails?.userImage = data["userPhoto"] as! String
        CurrenrCarDetails?.rate = data["rate"] as! Double
        
    }
    
    func FillDataFromAppData(){
        let carInfo = AppData.CarDetailsList[AppData.selectedCarId]
        carWeigth.text = (carInfo?.carWeigth)! + " тонн"
        carType.text = carInfo?.carType
        details.text = carInfo?.details
        PhoneNumberView.text = carInfo?.phoneNumber
        userName.text = carInfo?.userName
        carNumber.text = carInfo?.carNumber
        self.LoadingIndicator.isHidden = true


    }
    
    @IBAction func BackToMainView(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        self.present(nextViewController, animated:true, completion:nil)
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
    
    private func setRate(rate:Int){
        
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                DispatchQueue.main.async
                    {
                        self.fillStars(count: rate)
                }
                
            }
        
        
    }
    
    
    private func fillStars(count:Int){
        var i = 0
        while(i < count && i < 5){
            StarList[i].image = UIImage(named: "star-gold.png")
            i+=1
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
        
            if data != nil {
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
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                application.openURL(phoneCallURL as URL);
            }
        }
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
