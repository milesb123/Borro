//
//  DummyData.swift
//  Borro
//
//  Created by Miles Broomfield on 13/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import Foundation

struct DummyData{
    
    static let items = [Item(itemID: "XXX", sellerID: "XXX", title: "Cannon DSL 3600",category: "Technology and Gadgets", condition: "Good Condition", dailyPrice: 29, description: "Great Camera, Great Condition, contact me to borrow the camera, I’m available most week days for picks ups and drop offs", quantity: 1, pickUpLocation: "26 Watermint Quay, Craven Walk", images: []),Item(itemID: "XBX", sellerID: "AXX", title: "Cannon Lightweight 500",category: "Technology and Gadgets", condition: "Good Condition", dailyPrice: 20, description: "New camera given to me as a present",quantity: 0, pickUpLocation: "34 Judd Street", images: [])]
    
    static let users = [User(userID: "XXX", fullName: "Miles Broomfield", email: "milesbroomfield@yahoo.com",mobile:"07852973590",image: "", sellerBio: "Have a look at my stuff, I mainly have available Canon cameras"),User(userID: "AXX", fullName: "Jada Pinkett", email: "jadapinkett@gmail.com", mobile: "079307495", image: "", sellerBio: "In an entanglement, in the mean time you can borrow my stuff")]
    
    
}
