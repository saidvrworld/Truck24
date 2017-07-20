//
//  SignInDriver.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 19.03.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//


import Foundation


import UIKit



class SignInDriver: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var UserNameField: UITextField!
    @IBOutlet weak var AgreeButton: UIButton!
    @IBOutlet weak var SuccessRegistredView: UIView!
    @IBOutlet weak var car_weigth: UITextField!
    @IBOutlet weak var car_number: UITextField!
    @IBOutlet weak var car_details: UITextField!
    
    @IBOutlet weak var CarTypeButton: UIButton!
    
    
    private var agree:Bool = false
    var CheckBox = UIImage(named:"Checked.jpeg")
    var UnCheckBox = UIImage(named:"UnChecked.jpeg")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillFields()
        setDelegates()
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(SignInDriver.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    private func setDelegates(){
        self.UserNameField.delegate = self;
        self.car_weigth.delegate = self;
        self.car_number.delegate = self;
        self.car_details.delegate = self;
    }
    
    private func fillFields(){
        if(AppData.carType != nil){
            CarTypeButton.setTitle(AppData.carType, for: .normal)
        }
        if(AppData.userName != nil){
            UserNameField.text = AppData.userName
        }
        if(AppData.SignIn_details != nil){
            car_details.text = AppData.SignIn_details
        }
        if(AppData.SignIn_number != nil){
            car_number.text = AppData.SignIn_number
        }
        if(AppData.SignIn_weight != nil){
            car_weigth.text = AppData.SignIn_weight
        }
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    private func Registrate(){
        if(AppData.carTypeID == nil){
            NavigationManager.ShowError(errorText: "Вы не выбрали тип машины!",View: self)

            return
        }
        if(!(UserNameField.hasText)){
            NavigationManager.ShowError(errorText: "Вы не ввели имя!",View: self)

            return
        }
        if(!(car_weigth.hasText)){
            NavigationManager.ShowError(errorText: "Вы не указали вес машины!",View: self)

            return
        }
        
        if(!(car_number.hasText)){
            NavigationManager.ShowError(errorText: "Вы не ввели гос. номер машины!",View: self)

            return
        }
        if(agree){
            LoadingView.isHidden = false
            MakeRequest(urlstring: AppData.APIurl, userName: UserNameField.text!, token: AppData.token, maxWeigth: car_weigth.text!,carType: AppData.carTypeID, detail: car_details.text!,carNumber: car_number.text!)
        }
        else{
            NavigationManager.ShowError(errorText: "Вы не приняли наше соглашение!",View: self)

        }
        
    }
    
    private func MakeRequest(urlstring: String,userName: String,token:String,maxWeigth:String,carType:String,detail:String,carNumber:String){
        
        let parameters = "name="+userName+"&token="+token+"&maxWeight="+maxWeigth+"&carType="+carType+"&carNumber="+carNumber+"&detail="+detail
        print(parameters)
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                NavigationManager.ShowError(errorText: "Ошибка соединения!",View: self)

                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    self.ManageResponse(response:responseJSON)
                    DispatchQueue.main.async
                        {
                            self.SuccessRegistredView.isHidden = false
                    }
                    
                }
            }
        }
        
        task.resume()
        
    }
    
    private func ManageResponse(response:[String:Any]){
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                
                let registered = dataBody?["registered"] as! Int
                
                if(registered == 1){
                    
                    let defaults = UserDefaults.standard
                    defaults.set("1", forKey: localKeys.isRegistered)

                    print("Success registration")
                    print(dataBody?["userName"] as! String)
                    SuccessRegistredView.isHidden = false
                    AppData.registered = true
                }
                else{
                    AppData.registered = false
                }
            }
            
        }
        
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
    
    @IBAction func BackToSmsVerification(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "SMSVerification", View: self)
    }
    
    @IBAction func GoToChooseCarType(_ sender: Any) {
        AppData.lastScene = "SignInDriver"
        NavigationManager.MoveToScene(sceneId: "ChooseCarType", View: self)
            }
    
    @IBAction func GoToAgreement(_ sender: Any) {
        ShowAgreement()
    }
    
    @IBAction func GoToMainDriver(_ sender: Any) {
        NavigationManager.MoveToDriverMain(View: self)
    }
    
    @IBAction func FinishEnterName(_ sender: UITextField) {
        AppData.userName = sender.text!
    }
    
    @IBAction func FinishEnterWeight(_ sender: UITextField) {
        AppData.SignIn_weight = sender.text!

    }
    @IBAction func FinishEnterNumber(_ sender: UITextField) {
        AppData.SignIn_number = sender.text!

    }
    
    @IBAction func FinishEnterDetails(_ sender: UITextField) {
        AppData.SignIn_details = sender.text!
    }
    
    
    
    private func ShowAgreement(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        var PopView:PopUpViewController!
        PopView = storyBoard.instantiateViewController(withIdentifier: "AgreementPopUp") as! PopUpViewController
        self.addChildViewController(PopView)
        PopView.view.frame = self.view.frame
        self.view.addSubview(PopView.view)
        PopView.didMove(toParentViewController: self)
    }
    
}

