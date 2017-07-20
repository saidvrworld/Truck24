//
//  LogInCustomer.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 21.03.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//
import Foundation


import UIKit


//this is common class for driver and customer

class LogInCustomer: UIViewController {
    
    @IBOutlet weak var PhoneNumberField: UITextField!
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var SuccessView: UIView!

    var userType:String!
    var isLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(SignInDriver.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func AddChar(_ sender: UITextField) {
        if((sender.text?.characters.count)! == 9){
            self.view.endEditing(true)
            LogIn()
        }
    }
    
    func LogIn(){
     
        if(PhoneNumberField.text?.characters.count == 9){
                let number = PhoneNumberField.text
            if(!isLoading){
                isLoading = true
                self.ShowLoadingView(show: true)
                MakeRequest(urlstring: AppData.APIurl ,phone: number!)
            }
        }
        else{
            NavigationManager.ShowError(errorText: "Вы не ввели номер!",View: self)

            
        }
    }

    func MakeRequest(urlstring: String,phone: String){
        
        let parameters = "phoneNumber=%2B998"+phone+"&userType="+String(AppData.userType)

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
                            self.isLoading = false
                            NavigationManager.ShowError(errorText: "Ошибка соединения!",View: self)
                            self.ShowLoadingView(show: false)

                    }
                }
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                self.RegManager(response:responseJSON)
            }
        }
        
        task.resume()

    }
    
    func RegManager(response: [String:Any]){
        
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                self.isLoading = false
                let defaults = UserDefaults.standard
                let registered = (dataBody?["registered"]) as! Int

                if(registered != nil){
                    if(registered == 2){
                        self.ShowLoadingView(show: false)
                        var errorMessage = ""
                        if(AppData.userType == 1){  errorMessage =  "Вы уже зарегестрированы как водитель!"  }
                        else{   errorMessage =  "Вы уже зарегестрированы как заказчик!"  }
                        NavigationManager.ShowError(errorText: errorMessage, View: self)
                        
                    }
                    else{
                        AppData.token = dataBody?["token"] as! String
                        defaults.set(AppData.token, forKey: localKeys.token)
                        AppData.registered = true
                        self.ShowSuccessView(show: true)
                    }
                }
                else{
                    AppData.token = dataBody?["token"] as! String
                    defaults.set(AppData.token, forKey: localKeys.token)
                    AppData.registered = false
                    self.ShowSuccessView(show: true)

                    
                }

            }
        }
        //print(response["data"]["registered"])
    }
    
    func ShowSuccessView(show:Bool){
        DispatchQueue.main.async
            {
                self.SuccessView.isHidden = !show
        }

    }
    
    func ShowLoadingView(show:Bool){
        DispatchQueue.main.async
            {
                self.LoadingView.isHidden = !show
        }
        
    }
    
    @IBAction func nextStep(_ sender: Any) {
        self.ShowLoadingView(show: false)
        if(PhoneNumberField.text?.characters.count == 9 ){
            if(AppData.token != nil){
                NavigationManager.MoveToScene(sceneId: "SMSVerification",View: self)
            }
            else{
                NavigationManager.ShowError(errorText: "Ошибка соединения!",View: self)
            }
        }
        else{
            NavigationManager.ShowError(errorText: "Вы не ввели номер!",View: self)
        }

    }
    
    
    
    @IBAction func BackToChooseType(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "ChooseType",View:self)

    }
    
    
}
