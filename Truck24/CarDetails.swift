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
        MakeRequest(urlstring: AppData.CarInfoUrl, carId: String(AppData.selectedCarId))

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MakeCall(_ sender: Any) {
        
    }
    
    func MakeRequest(urlstring: String,carId: String){
        
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
    
    func InfoManager(response: [String:Any]){
        
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                var userNameData = dataBody?["userName"] as! String
                userName.text = userNameData
                print(userNameData)
                carNumber.text = dataBody?["carNumber"] as! String
                carWeigth.text = dataBody?["carMaxWeight"] as! String
                carType.text = dataBody?["carName"] as! String
                details.text = dataBody?["detail"] as! String
                PhoneNumberView.text = dataBody?["phoneNumber"] as! String
                
                setCarPicture(dataBody?["carImageUrl"] as! String)
                setUserPicture(dataBody?["userPhoto"] as! String)
                LoadingIndicator.isHidden = true
                var carRate = dataBody?["rate"] as! Double
                var carIntRate = Int(carRate)
                var i = 0
                //while(i < carIntRate && i < 5){
                  //StarList[i].image = UIImage(named: "star-gold.png")
                //}

            }
            
        }
        
    }
    
       
    
    
    @IBAction func BackToMainView(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func setCarPicture(_ url:String){
        if(self.isCarImageLoading){
            //self.Loading.startAnimating()
        }
        if(!isCarImageLoading){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async{
                self.carImage.image =  self.DownloadCarImage(url)
                DispatchQueue.main.async
                    {
                        self.isCarImageLoading = false
                }
                
            }
        }
        
    }
    
    
    func DownloadCarImage(_ imgUrl:String)->UIImage{
        self.isCarImageLoading = true
        var Image: UIImage?
        let url = URL(string:imgUrl)
        let data = try? Data(contentsOf: url!)
        if data!.count > 0 {
            Image = UIImage(data:data!)
        } else {
            Image = UIImage(named: "placeholder.jpg")
        }
        //self.Loading.stopAnimating()
        return Image!
    }
    
    func setUserPicture(_ url:String){
        if(self.isUserImageLoading){
            //self.Loading.startAnimating()
        }
        if(!isUserImageLoading){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async{
                self.userImage.image =  self.DownloadUserImage(url)
                DispatchQueue.main.async
                    {
                        self.isUserImageLoading = false
                }
                
            }
        }
        
    }
    
    
    func DownloadUserImage(_ imgUrl:String)->UIImage{
        self.isUserImageLoading = true
        var Image: UIImage?
        let url = URL(string:imgUrl)
        let data = try? Data(contentsOf: url!)
        if data!.count > 0 {
            Image = UIImage(data:data!)
        } else {
            Image = UIImage(named: "placeholder.jpg")
        }
        //self.Loading.stopAnimating()
        return Image!
    }
    
}
