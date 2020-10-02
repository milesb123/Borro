//
//  URLImage.swift
//  Borro
//
//  Created by Miles Broomfield on 19/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct URLImage: View {
    
    private var imageLoader = ImageLoader()
    
    var placeholder: Image
    
    @State var imageDisplayed:Image = Image(systemName: "photo")
    
    var body: some View {
        imageDisplayed
            .onReceive(imageLoader.$downloadedImage) { (uiImage) in
                if let image = uiImage{
                    self.imageDisplayed = Image(uiImage: image)
                }
                else{
                    self.imageDisplayed = self.placeholder
                }
            }
    }
    
    init(url:String, placeholder:Image = Image(systemName: "photo")){
        self.placeholder = placeholder
        self.imageLoader.loadFromURL(url: url)
    }
}

struct URLImage_Previews: PreviewProvider {
    static var previews: some View {
        URLImage(url: "https://static01.nyt.com/images/2018/11/14/arts/cam1/cam1-superJumbo.jpg")
    }
}
