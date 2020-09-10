//
//  Objects.swift
//  Borro
//
//  Created by Miles Broomfield on 13/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import Foundation
import SwiftUI

struct User{
    let userID:String
    let fullName:String
    let email:String
    let mobile:String
    let image:UIImage?
    let sellerBio:String
}

struct Item{
    let itemID:String
    let sellerID:String
    let title:String
    let category:String
    let condition:String
    let dailyPrice:Double
    let description:String
    let quantity:Int
    let pickUpLocation:String
    let images:[String] = []
}

struct Borrow{
    let borrowID:String
    let userID:String
    let itemID:String
    let dateTimeBorrowed:String
    let quantityBorrowed:Int
    let status:String
}

struct Review{
    let reviewID:String
    let itemID:String
    let fullName:String
    let rating:String
    let comment:String
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
    let category:String
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

