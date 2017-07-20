//
//  SignInCustomer.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 06.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit

class SignInCustomer: UIViewController {
    
    @IBOutlet weak var UserNameField: UITextField!
    @IBOutlet weak var AgreeButton: UIButton!
    
    @IBOutlet weak var LoadingView: UIView!
    
    @IBOutlet weak var SuccessRegisteredView: UIView!
    
    let APIurl:String = "http://track24.beetechno.uz/api/"
    var agree:Bool = false
    var CheckBox = UIImage(named:"Checked.jpeg")
    var UnCheckBox = UIImage(named:"UnChecked.jpeg")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SuccessRegisteredView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func GoToLogIn(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "LogInCustomer", View: self)
    }
    
    
    @IBAction func SwitchOn(_ sender: UIButton) {
        if(!agree){
            agree = true
            AgreeButton.setImage(CheckBox,for: UIControlState.normal)

            ShowAgreement()
        }
        else{
            agree = false
            AgreeButton.setImage(UnCheckBox,for: UIControlState.normal)
        }
        
    }
    
    @IBAction func AcceptRegistration(_ sender: Any) {
        Registrate()
    }
    
    func Registrate(){
        if(UserNameField.hasText){
            
            if(agree){
                LoadingView.isHidden = false
                MakeRequest(urlstring: APIurl, userName: UserNameField.text!, token: AppData.token)
            }
            else{
                NavigationManager.ShowError(errorText: "Вы не приняли наше соглашение!",View: self)

            }
        }
        else{
            NavigationManager.ShowError(errorText: "Вы не ввели имя!",View: self)

        }
        
    }
    
    func MakeRequest(urlstring: String,userName: String,token:String){
        
        let parameters = "name="+userName+"&token="+token
        print(parameters)
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url)
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
                    self.ManageResponse(response:responseJSON)
                    DispatchQueue.main.async
                        {
                            self.SuccessRegisteredView.isHidden = false
                    }
                    
                }
            }
        }
        
        task.resume()
        
    }
    
    func ManageResponse(response:[String:Any]){
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                
                let registered = dataBody?["registered"] as! Int

                if(registered == 1){
                    
                    let defaults = UserDefaults.standard
                    defaults.set("1", forKey: localKeys.isRegistered)
                    
                    print("Success registration")
                    print(dataBody?["userName"] as! String)
                    AppData.registered = true
                    DispatchQueue.main.async
                        {
                            self.SuccessRegisteredView.isHidden = false
                    }
                }
                else{
                    
                    AppData.registered = false
                }
            }
            
        }
        
    }
    
    @IBAction func GoToAgreement(_ sender: Any) {
        ShowAgreement()
    }
    
    private func GoToNearList() {
        NavigationManager.MoveToCustomerMain(View: self)
    }
    
    @IBAction func NextStep(_ sender: Any) {
        GoToNearList()
    }
    
    
    private func ShowAgreement(){
        self.view.endEditing(true)

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        var PopView:PopUpViewController!
        PopView = storyBoard.instantiateViewController(withIdentifier: "AgreementPopUp") as! PopUpViewController
        self.addChildViewController(PopView)
        PopView.view.frame = self.view.frame
        self.view.addSubview(PopView.view)
        PopView.didMove(toParentViewController: self)
    }
    
    
}
