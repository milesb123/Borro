//
//  ImageTest.swift
//  Borro
//
//  Created by Miles Broomfield on 19/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

struct ImageTest: View {
    
    @State var image:Image?
    
    @State var imagePickerPresented:Bool = false
    @State var inputImage:UIImage?
    
    var body: some View {
        VStack{
            /*
            URLImage(url: "https://firebasestorage.googleapis.com/v0/b/borro-973e8.appspot.com/o/borro_image.png?alt=media&token=2cd4ed81-6986-415c-b55b-3dc7e2c86746")
            */
            StorageImage(fullPath: "TgBXpiVAxxd0ozhNJEhn/profile_images/easyname", cornerRadius: 20, height: 160)
            
            ZStack{
                Button(action:{self.presentPicker()})
                {
                    if(self.image != nil){
                        self.image?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:200,height:200)
                        Button(action:{self.uploadImage()}){Text("Upload Image")}
                    }
                    else{
                        Text("Insert Image")
                    }
                }
                
                if(self.imagePickerPresented){
                    ImagePicker(image: self.$inputImage, onFinishedPicking: self.finishedPicking)
                }

            }
        }
    }
    
    func finishedPicking() -> Void{
        self.loadImage()
        self.imagePickerPresented = false
    }
    
    func presentPicker(){
        self.imagePickerPresented = true
    }
    
    func loadImage(){
        guard let inputImage = inputImage else { return }
        self.image = Image(uiImage: inputImage)
        
    }
    
    func uploadImage(){
        
        let storage = Storage.storage().reference()
        if let data = self.inputImage?.pngData(){
            let path = storage.child("itemID/images/\(UUID().description)")
            path.putData(data, metadata: nil) { (metadata, err) in
                guard let metadata = metadata else{
                    return
                }
            }
        }
        
    }
    
}


struct ImageTest_Previews: PreviewProvider {
    static var previews: some View {
        ImageTest()
    }
}
