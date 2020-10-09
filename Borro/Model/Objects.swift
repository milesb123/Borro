//
//  Objects.swift
//  Borro
//
//  Created by Miles Broomfield on 13/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

struct User{
    let userID:String
    let fullName:String
    let email:String
    let mobile:String
    let image:String
    let sellerBio:String
}

class Item:ObservableObject{
    
    let itemID:String
    let sellerID:String
    let title:String
    let categories:[String]
    let condition:String
    let dailyPrice:Double
    let description:String
    let quantity:Int
    let pickUpLocation:String
    let images:[String]
    
    init(itemID:String,sellerID:String,title:String,categories:[String],condition:String,dailyPrice:Double,description:String,quantity:Int,pickUpLocation:String,images:[String]){
        self.itemID = itemID
        self.sellerID = sellerID
        self.title = title
        self.categories = categories
        self.condition = condition
        self.dailyPrice = dailyPrice
        self.description = description
        self.quantity = quantity
        self.pickUpLocation = pickUpLocation
        self.images = images
    }
    
}


struct Category{
    let category:String
}

struct Filter{
    
}

struct Search{
    
    let text:String
    let filters:[Filter]
    let category = "None"
    
}

struct ItemSubmission{
    let sellerID:String
    let title:String
    let categories:[String]
    let condition:String
    let dailyPrice:Double
    let description:String
    let quantity:Int
    let pickUpLocation:String
}


struct UserSubmission{
    let userID:String
    let fullName:String
    let email:String
    let mobile:String
    let imageRef:String
    let sellerBio:String
}

struct Categories{
    static var categories:[String] = ["Animals and Pet Supplies","Apparel and Accessories","Arts and Entertainment","Baby and Toddler","Business and Industrial","Camera and Optics","Electronics","Food, Beverages and Tobacco","Furniture","Hardware and Tools","Health and Beauty","Home and Garden","Mature","Media","Office Supplies","Software","Sporting Goods","Toys and Games","Vehicles and Parts"]
}
