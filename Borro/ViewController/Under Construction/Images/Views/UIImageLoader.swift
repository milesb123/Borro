//
//  UIImageLoader.swift
//  Borro
//
//  Created by Miles Broomfield on 21/09/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct UIImageLoader: View{

    var placeholder:Image
    
    let width:CGFloat?
    let height:CGFloat?
    let cornerRadius:CGFloat
    
    @State var image:UIImage?
    
    var body: some View {
        Group{
            //Image(uiImage:image)
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
    
    init(uiimage, placeholder:Image = Image(systemName: "photo"), cornerRadius:CGFloat = 0, width:CGFloat? = nil, height:CGFloat? = nil){
        self.placeholder = placeholder
        self.cornerRadius = cornerRadius
        self.width = width
        self.height = height
        
    }
    
}
struct UIImageLoader_Previews: PreviewProvider {
    static var previews: some View {
        UIImageLoader()
    }
}
