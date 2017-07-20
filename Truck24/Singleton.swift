//
//  Singleton.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 05.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import MapKit


class AppData{
    static let sharedInstance = AppData()
    
    static var CarTypeList: [CarType] = []
    static var CarList: [CarShort] = []
    static var PubList: [Publication] = []
    static var DonePubList: [Publication] = []
    static var OrderForDriverList: [OrderForDriver] = []
    static var MyOrderForDriverList: [MyOrderForDriver] = []
    static var CarDetailsList:[Int:CarDetail] = [:]
    static var PubDetailsList:[Int:PubDetail] = [:]
    
    
    static let GoogleDirectionsAPIKey = "AIzaSyAUComXSojxXy1aJDjq7MuDNT1XqVu6VTU"
    static let GoogleDirectionsAPIUrl = "https://maps.googleapis.com/maps/api/directions/json"

    
    static let APIurl: String = "http://track24.beetechno.uz/api/"
    static let nearFilteredListUrl: String = "http://track24.beetechno.uz/api/customer/getFilteredNearAds/"
    static let nearListUrl: String = "http://track24.beetechno.uz/api/customer/getNearAds/"
    static let CarInfoUrl: String = "http://track24.beetechno.uz/api/customer/getNearInfo/"
    static let getPublicationsUrl: String = "http://track24.beetechno.uz/api/customer/getOrders/"
    static let getFinishedPublicationsUrl: String = "http://track24.beetechno.uz/api/customer/getFinishedOrders/"
    static let addPublicationsUrl: String = "http://track24.beetechno.uz/api/customer/addOrders/"
    static let getCarTypesUrl: String = "http://track24.beetechno.uz/api/customer/carTypes/"
    static let getPublicationInfoUrl: String = "http://track24.beetechno.uz/api/customer/getOrderInfo/"
    static let getOffersUrl: String = "http://track24.beetechno.uz/api/customer/getOffers/"
    static let getOfferInfoUrl: String = "http://track24.beetechno.uz/api/customer/getOfferInfo/"
    static let getOrdersForDriverUrl = "http://track24.beetechno.uz/api/driver/getOrders/"
    static let getOrderInfoForDriverUrl = "http://track24.beetechno.uz/api/driver/getOrderInfo/"
    static let makeOfferUrl = "http://track24.beetechno.uz/api/driver/makeOffer/"
    static let getMyOrdersForDriverUrl = "http://track24.beetechno.uz/api/driver/myOrders/"
    static let getMyFinishedOrdersForDriverUrl = "http://track24.beetechno.uz/api/driver/myFinishedOrders/"
    static let acceptOfferUrl = "http://track24.beetechno.uz/api/customer/acceptOffer/"
    static let acceptedOrderInfoUrl = "http://track24.beetechno.uz/api/customer/acceptedOrderInfo/"
    static let closeOrderDriverUrl = "http://track24.beetechno.uz/api/driver/closeOrder/"
    static let closeOrderCustomerUrl = "http://track24.beetechno.uz/api/customer/closeOrder/"
    static let setRateForDriverUrl = "http://track24.beetechno.uz/api/customer/rate/"
    static let setImageForDriverUrl = "http://track24.beetechno.uz/api/driver/uploadPhoto/"
    static let DriverInfoForDriver = "http://track24.beetechno.uz/api/driver/getDriverInfo/"
    
    static var userType = 0
    static var userName:String!
    static var registered:Bool = true
    static var token:String!
    static var phoneNumber:String = "0"
    static var carType:String!
    static var carTypeID:String!
    static var selectedCarId:Int = 0
    static var selectedPubId:Int = 0
    static var selectedOfferId:Int = 0
    static var selectedOrderForDriverId:Int = 0
    static var notes:String!
    static var SignIn_weight:String!
    static var SignIn_details:String!
    static var SignIn_number:String!
    static var UpdateInterval = 50.0

    
    static var SendStatus:String!
    static var currentLocation:CLLocation!
    static var fromLocation:CLLocation!
    static var toLocation:CLLocation!
    static var DriverLocation:CLLocation!
    static var waitingForLoc:String = "None"
    static var lastScene:String = "None"
    static var lastDetailsScene:String!
    static var PopUpErrorText:String!

    static func ClearDB(){
        for timer in NavigationManager.TimerList{
            timer.invalidate()
        }
        AppData.token = nil
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: localKeys.smsSubmited)
        defaults.set(nil, forKey: localKeys.userType)
        defaults.set(nil, forKey: localKeys.token)
        defaults.set(nil, forKey: localKeys.isRegistered)
        
    }
}

class NavigationManager{
    static let sharedInstance = NavigationManager()
    static var LocationTimer:Timer!
    static var TimerList:[Timer]=[]


    static func MoveToScene(sceneId:String,View:UIViewController){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: sceneId) as! UINavigationController
        View.present(nextViewController, animated:true, completion:nil)
    }
    
    static func MoveToDriverMain(View:UIViewController){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainDriverView") as! UITabBarController
        View.present(nextViewController, animated:true, completion:nil)
    }
    
    static func MoveToCustomerMain(View:UIViewController){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        View.present(nextViewController, animated:true, completion:nil)
    }
    
    static func ShowError(errorText:String,View:UIViewController){
        AppData.PopUpErrorText = errorText
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let PopView = storyBoard.instantiateViewController(withIdentifier: "DinamicPopUp") as! DinamicPopUp
        View.addChildViewController(PopView)
        PopView.view.frame = View.view.frame
        View.view.addSubview(PopView.view)
        PopView.didMove(toParentViewController: View)
    }
    
    static func StopTimers(){
        for timer in NavigationManager.TimerList{
            timer.invalidate()
        }
    }
    
    static func StopSendLoc(){
        //NavigationManager.LocationTimer!.invalidate()
    }

}

struct localKeys {
    static let userType = "userType"
    static let token = "token"
    static let userName = "userName"
    static let isRegistered = "isRegistered"
    static let smsSubmited = "smsSubmited"
    static let sendStatus = "sendStatus"


}
