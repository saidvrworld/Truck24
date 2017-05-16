//
//  SMSVerification.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 07.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation


import UIKit

class SMSVerification: UIViewController {

    
    
    @IBOutlet weak var SMSCode: UITextField!
    
    var successCode: Bool = false
    var isRegistrated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func AcceptCode() {
        MakeRequest(urlstring: AppData.APIurl, code: SMSCode.text!, token: AppData.token)
    }
    
    @IBAction func BackToLogIn(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LogInCustomer") as! LogInCustomer
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func MakeRequest(urlstring: String,code: String,token:String){
        
        let parameters = "smsResponse="+code+"&token="+token
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
                            self.ShowError(errorType: "connectError")
                            
                    }
                    
                }
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                self.CheckCode(response:responseJSON)
                
            }
        }
        
        task.resume()

        
    }
    
    func CheckCode(response: [String:Any]){
        
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                let success = dataBody?["success"] as! Bool
                let registered = dataBody?["registered"] as! Int
                let userName = dataBody?["userName"] as? String
                
                

                if(success){
                    print("Success sms Code Verification")
                    successCode = true
                    
                    AppData.token = (dataBody?["token"] as? String)!
                    
                    let defaults = UserDefaults.standard
                    defaults.set(AppData.token, forKey: localKeys.token)
                    
                    if(registered == 1){
                        isRegistrated = true
                        defaults.set("1", forKey: localKeys.isRegistered)
                        AppData.userName = userName!
                        defaults.set(AppData.userName, forKey: localKeys.userName)
                        print(AppData.userName)
                    }
                    else{
                        defaults.set("0", forKey: localKeys.isRegistered)
                        isRegistrated = false
                    }
                }
                else{
                    successCode = false
                }
                
            }
        }
        
    }
    
    @IBAction func AddChar(_ sender: UITextField) {
        if((sender.text?.characters.count)! == 5){
            AcceptCode()
        }
    }
    
    
    @IBAction func NextStep(_ sender: Any) {
        if((SMSCode.text?.characters.count)! < 5){
            ShowError(errorType: "NotEnterCode")
        }else{
            if(successCode){
                if(isRegistrated){
                    GoToNearList()
                }else{
                    GoToRegistration()
                }
            }else{
                ShowError(errorType: "smsError")
            }
        }
    }
    
    func GoToNearList() {
        if(AppData.userType == 1){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        self.present(nextViewController, animated:true, completion:nil)
        }
        else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainDriverView") as! UITabBarController
            self.present(nextViewController, animated:true, completion:nil)

        }
    }
    
    func GoToRegistration() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if(AppData.userType==1){
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignInCustomer") as! SignInCustomer
            self.present(nextViewController, animated:true, completion:nil)
            
        }
        else{
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignInDriver") as! SignInDriver
            self.present(nextViewController, animated:true, completion:nil)
            
        }
        
    }
    
    func ShowError(errorType: String){
        
        if(errorType=="smsError"){
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let PopView = storyBoard.instantiateViewController(withIdentifier: "wrongSms") as! PopUpViewController
            self.addChildViewController(PopView)
            PopView.view.frame = self.view.frame
            self.view.addSubview(PopView.view)
            PopView.didMove(toParentViewController: self)
        }
        else if(errorType=="NotEnterCode"){
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let PopView = storyBoard.instantiateViewController(withIdentifier: "NotEnterCode") as! PopUpViewController
            self.addChildViewController(PopView)
            PopView.view.frame = self.view.frame
            self.view.addSubview(PopView.view)
            PopView.didMove(toParentViewController: self)
        }
        else if(errorType=="connectError"){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let PopView = storyBoard.instantiateViewController(withIdentifier: "badConnection") as! PopUpViewController
            self.addChildViewController(PopView)
            PopView.view.frame = self.view.frame
            self.view.addSubview(PopView.view)
            PopView.didMove(toParentViewController: self)
        }
        
    }
}


private var __maxLengths = [UITextField: Int]()

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        let c = self.characters
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
}
