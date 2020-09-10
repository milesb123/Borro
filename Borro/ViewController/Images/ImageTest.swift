//
//  ImageTest.swift
//  Borro
//
//  Created by Miles Broomfield on 19/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct ImageTest: View {
    
    @State var image:Image?
    
    var body: some View {
        VStack{
            URLImage(url: "https://firebasestorage.googleapis.com/v0/b/borro-973e8.appspot.com/o/borro_image.png?alt=media&token=2cd4ed81-6986-415c-b55b-3dc7e2c86746")
            
            StorageImage(fullPath: "user/borro_image.png", cornerRadius: 20, height: 160)
            
        }
    }
    
}


struct ImageTest_Previews: PreviewProvider {
    static var previews: some View {
        ImageTest()
    }
}
