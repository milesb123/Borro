//
//  ImageLoader.swift
//  Borro
//
//  Created by Miles Broomfield on 19/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import Firebase
import FirebaseStorage

class ImageLoader{
    
    @Published var downloadedImage:UIImage?
    
    func loadFromURL(url:String){
        
        guard let imageURL = URL(string: url) else{
            fatalError("Image URL is not correct")
        }
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            
            guard let data = data,error == nil else{
                DispatchQueue.main.async {
                    self.downloadedImage = nil
                }
                return
            }
            
            DispatchQueue.main.async {
                self.downloadedImage = UIImage(data: data)
            }
            
        }.resume()
    }
    
    func loadFromFirebase(fullPath:String,completionHandler: @escaping(Error?) -> Void){
        
        Storage.storage().reference(withPath: fullPath).getData(maxSize: 1 * 2048 * 2048) { (data, err) in
            if let err  = err{
                completionHandler(err)
            }
            if let data = data{
                self.downloadedImage = UIImage(data: data)
                completionHandler(nil)
            }
        }
    }
    
}
