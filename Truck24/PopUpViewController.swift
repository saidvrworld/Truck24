//
//  PopUpViewController.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 21.03.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ClosePopUp(_ sender: Any) {
        
        self.view.removeFromSuperview()
    }
    


}

class DinamicPopUp: UIViewController {
    
    @IBOutlet weak var ErrorText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorText.text = AppData.PopUpErrorText
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ClosePopUp(_ sender: Any) {
        
        self.view.removeFromSuperview()
    }
    
}


class OfferPrice: UIViewController {
    
    @IBOutlet weak var price: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(SignInDriver.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        // Do any additional setup after loading the view.
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }

    
    @IBAction func SendOffer(_ sender: Any) {
        if(price.hasText){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
 self.RequestOffer(urlstring: AppData.makeOfferUrl, orderId: String(AppData.selectedOrderForDriverId), token: AppData.token, price: self.price.text!)
                DispatchQueue.main.async
                    {
                        self.BackToMain()
                }
            }
           
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ClosePopUp(_ sender: Any) {
        
        self.view.removeFromSuperview()
    }
    
    private func RequestOffer(urlstring: String,orderId: String,token:String,price:String){
        
        let parameters = "token=fec5fdf5ac012r43"+orderId+"fec5fdf5ac012r43"+"&userId="+token+"&price="+price
        
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
    
    private func InfoManager(response: [String:Any]){
        
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                
                let success = dataBody?["success"] as! Bool
                if(success){
                    print("You make offer"+price.text!)
                                        
                }
               
            }
            
        }
        
    }
    
   private func BackToMain() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainDriverView") as! UITabBarController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
       
}


class SetDriverRateWindow: UIViewController {
    
    @IBOutlet weak var ratingBoard: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SetRate(_ sender: Any) {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                self.RequestRate(rate: (self.ratingBoard.selectedSegmentIndex+1))
                DispatchQueue.main.async
                    {
                        self.BackToMain()
                }
            
           }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ClosePopUp(_ sender: Any) {
        self.BackToMain()
        //self.view.removeFromSuperview()
    }
    
    private func RequestRate(rate:Int){
        let urlstring = AppData.setRateForDriverUrl
        let parameters = "rate=fec5fdf5ac012r43"+String(rate)+"fec5fdf5ac012r43&token=fec5fdf5ac012r43"+String(AppData.selectedPubId)+"fec5fdf5ac012r43"+"&userId="+AppData.token
        
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
                print(responseJSON)
                self.AnswerManager(response:responseJSON)
            }
        }
        
        task.resume()
        
    }
    
    private func AnswerManager(response: [String:Any]){
        
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                
                let success = dataBody?["success"] as! Bool
                if(success){

                    print("You rate"+String(ratingBoard.selectedSegmentIndex+1))
                }
                
            }
            
        }
        
    }
    
    
     func BackToMain() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        self.present(nextViewController, animated:true, completion:nil)
        
    }

    
}
