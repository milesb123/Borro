//
//  Enums.swift
//  Borro
//
//  Created by Miles Broomfield on 19/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import Foundation

enum FirebaseError:Error{
    
    case invalidNumberOfDocumentsReturned
    
}

enum itemsFirebase:String{
    
    case sellerID
    
    case title
    
    case description
    
    case category
    
    case avQuantity
    
    case maxQuantity
    
    case condition
    
    case dailyPrice
    
    case dateAdded
    
    case pickUpLocation
    
    case status
    
    case images
    
    
}

enum usersFirebase:String{
    
    case authID
    
    case fullName
    
    case email
    
    case mobile
    
    case sellerBio
    
    case imageRef
    
    case dateJoined
    
}

enum searchCategories:String{
    
    case Camera
    
}
