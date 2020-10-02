//
//  StorageTest.swift
//  Borro
//
//  Created by Miles Broomfield on 21/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseStorage

class StorageTest{
    
    let storage = Storage.storage().reference(withPath: "borro_image.png")
    
    static let shared = StorageTest()
    
    @Published var img:UIImage?
    
    func imageTest1(completionHandler: @escaping(Error?) -> Void){
        storage.getData(maxSize: 1 * 2048 * 2048) { (data, err) in
            if let err  = err{
                completionHandler(err)
            }
            if let data = data{
                self.img = UIImage(data: data)
                completionHandler(nil)
            }
        }
    }
}
