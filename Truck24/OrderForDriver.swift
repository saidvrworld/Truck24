//
//  OrderForDriver.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 10.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation



import UIKit


class OrderForDriver{
    var notes: String!
    var orderId: Int!
    var date_of_execution:String!
    var addressFrom: String?
    
}

class MyOrderForDriver{
    var userName: String!
    var orderId: Int!
    var date_of_execution:String!
}

class OrderForDriverCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var notes: UILabel!
    
    var orderId:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func createCell(order: OrderForDriver){
        orderId = order.orderId
        Address.text = order.addressFrom
        date.text = order.date_of_execution
        notes.text = order.notes
       
    }
    
}

class MyOrderForDriverCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var customerName: UILabel!
    
    var orderId:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func createCell(order: MyOrderForDriver){
        orderId = order.orderId
        date.text = order.date_of_execution
        customerName.text = order.userName
        
    }
    
}
