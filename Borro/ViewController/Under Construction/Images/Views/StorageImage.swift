//
//  StorageImage.swift
//  Borro
//
//  Created by Miles Broomfield on 21/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct StorageImage: View{
    
    var imageLoader = ImageLoader()
    
    var placeholder:Image
    
    let width:CGFloat?
    let height:CGFloat?
    let cornerRadius:CGFloat
    
    @State var image:Image?
    
    let contentMode:ContentMode
    
    var body: some View {
        Group{
            self.image?
                .resizable()
                .aspectRatio(contentMode: self.contentMode)
                .frame(width: width, height: height)
                .clipped()
                .cornerRadius(cornerRadius)
        }
            .onReceive(imageLoader.$downloadedImage) { (uiImage) in
                if let image = uiImage{
                    self.image = Image(uiImage: image)
                }
                else{
                    self.image = self.placeholder
                }
            }
    }
    
    init(fullPath:String, placeholder:Image = Image(systemName: "photo"), cornerRadius:CGFloat = 0, width:CGFloat? = nil, height:CGFloat? = nil, contentMode:ContentMode = .fill){
        self.placeholder = placeholder
        self.imageLoader.loadFromFirebase(fullPath: fullPath) { (err) in
            if let err = err{
                print(err)
            }
        }
        self.cornerRadius = cornerRadius
        self.width = width
        self.height = height
        self.contentMode = contentMode
    }
    
}

struct StorageImageV2: View{

    //load data from image loader into an Image as a function
    
    private var imageLoader = ImageLoader()

    var placeholder:Image

    let width:CGFloat?
    let height:CGFloat?
    let cornerRadius:CGFloat

    @State var image:Image?

    var body: some View {
        Group{
            self.image?
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .clipped()
                .cornerRadius(cornerRadius)
        }
            .onReceive(imageLoader.$downloadedImage) { (uiImage) in
                if let image = uiImage{
                    self.image = Image(uiImage: image)
                }
                else{
                    self.image = self.placeholder
                }
            }
    }

    init(fullPath:String, placeholder:Image = Image(systemName: "photo"), cornerRadius:CGFloat = 0, width:CGFloat? = nil, height:CGFloat? = nil){
        self.placeholder = placeholder
        self.imageLoader.loadFromFirebase(fullPath: fullPath) { (err) in
            if let err = err{
                print(err)
            }
        }
        self.cornerRadius = cornerRadius
        self.width = width
        self.height = height
        
    }
}

struct StorageImage_Previews: PreviewProvider {
    static var previews: some View {
        StorageImage(fullPath: "borro_image.png")
    }
}
