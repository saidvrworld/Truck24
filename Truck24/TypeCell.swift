//
//  TypeCell.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 06.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation


import UIKit
class CarType{
 
    var type: String?
    var id: Int?
    var category: Int?
    var imgUrl:String?
    
}


class TypeCell: UITableViewCell {
    
    @IBOutlet weak var Category: UILabel!
    var ID:Int!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Check: UIImageView!
    @IBOutlet weak var CarImage: UIImageView!
    var isLoading: Bool = false
    var CachImage:UIImage?


    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func Choose(){
        AppData.carTypeID = String(ID)
        AppData.carType = Name.text
    }
    
    func UnChoose(){
        self.Check.isHidden = true
    }
    
    
    func createCell(type:CarType){
        Name.text = type.type
        ID = type.id
        if(type.category == 1){
            Category.text = "Малотоннажные"
            if(ID != 5){
               Name.text = Name.text!+"(Damas Labo)"
            }
        }
        else if(type.category == 2){
            Category.text = "Среднетонажные"
        }
        else if(type.category == 3){
            Category.text = "Тяжелотоннажные"
        }
        else if(type.category == 4){
            Category.text = "Спец.Техника"
        }
        addPicture(type.imgUrl!)
        
    }
    
    private func addPicture(_ url:String){
        if(self.isLoading){
            //self.Loading.startAnimating()
            DispatchQueue.main.async
                {
                    self.CarImage.image = UIImage(named: "placeholder.jpg")
            }
        }
        if(!isLoading){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async{
                self.CachImage =  self.DownloadImage(url)
                DispatchQueue.main.async
                    {
                        self.CarImage.image =  self.CachImage
                        self.isLoading = false
                }
                
            }

        }
        
    }
    
   
    
    
    private func DownloadImage(_ imgUrl:String)->UIImage{
        self.isLoading = true
        var Image: UIImage?
        let url = URL(string:imgUrl)
        let data = try? Data(contentsOf: url!)
        if data != nil {
            Image = UIImage(data:data!)
        } else {
            Image = UIImage(named: "placeholder.jpg")
        }
        if(Image == nil){
            Image = UIImage(named: "placeholder.jpg")
            
        }
        //self.Loading.stopAnimating()
        return Image!
    }
    

    
    
}
