//
//  EditProfile.swift
//  Borro
//
//  Created by Miles Broomfield on 20/09/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct EditProfile: View {
    @EnvironmentObject var viewRouter:ViewRouter
    
    @Binding var user:User
    
    @State var inputImage:UIImage?
    @State var pickerPresented:Bool = false

    @State var fullName = ""
    @State var email = ""
    @State var mobile = ""
    @State var sellerBio = ""
    
    var body : some View{
        VStack{
            VStack{
                HStack{
                    Text("Edit Profile")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action:{self.dismissModal()}){Image(systemName:"xmark.circle.fill").resizable().frame(width:30,height:30).foregroundColor(Color("Teal"))}
                }
                HStack{
                    Text("Use the sections below to edit your profile and tap submit to save your changes")
                        .font(.headline)
                        .fontWeight(.light)
                    Spacer()
                }
                .padding(.top)
            }
            ScrollView(showsIndicators: false){
                VStack(spacing:20){
                VStack{
                    Text("Tap the camera to change your profile picture")
                        .font(.subheadline)
                        .fontWeight(.light)
                    ZStack{
                        if(self.inputImage != nil){
                            self.uploadedImage()
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width:180,height:180)
                        }
                        else if(false){
                            StorageImage(fullPath: user.image, width: 180, height: 180)
                                .clipShape(Circle())
                                // Replace second unwrap with uiimage loaded from assets, as this unwrap is unsafe
                            .onAppear{
                                print("loaded from image data")
                            }
                        }
                        else{
                            Image(systemName: "person.crop.circle.fill")//Default picture needed
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .foregroundColor(Color("lightGray"))
                                .frame(width:180,height:180)
                        }
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Button(action:{self.pickerPresented = true}){
                                    Circle()
                                        .frame(width:40,height:40)
                                        .foregroundColor(Color.white)
                                        .overlay(Image(systemName:"camera.circle.fill").resizable().foregroundColor(Color("Teal")))
                                }
                            }
                        }
                    }
                    .frame(width:150,height:150)
                    .padding(.top)
                }
                .padding(.top)
                VStack(alignment: .leading){
                    Text("About Me")
                        .font(.headline)
                        .fontWeight(.bold)
                    ZStack{
                        Rectangle()
                            .stroke(lineWidth: 1)
                            .foregroundColor(Color("lightGray"))
                        TextField("Enter Field", text: $sellerBio)
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(5)
                            .frame(height:80)
                    }
                    
                }
                //.padding(.vertical,20)
                Button(action:{self.submitChanges()}){Capsule().frame(width:150,height:60).foregroundColor(Color("Teal")).overlay(Text("Submit").font(.headline).fontWeight(.bold).foregroundColor(Color.white))}
                    .padding(.vertical)
                Spacer()
                    .frame(height: UIScreen.main.bounds.height*0.4)
            }
            }
        }
        .padding()
        .onAppear{
            self.fullName = self.user.fullName
            self.email = self.user.email
            self.mobile = self.user.mobile
            self.sellerBio = self.user.sellerBio
        }
        .onReceive(Session.shared.$localUser) { (user) in
            if let user = user{
                self.user = user
            }
        }
        .sheet(isPresented: $pickerPresented, content: {
            ImagePicker(image: $inputImage, onFinishedPicking: self.finishedPickingImage)
        })
    }
    
    func finishedPickingImage(){
        self.pickerPresented = false
        
    }
    
    func uploadedImage() -> Image{
        guard let inputImage = self.inputImage else { return Image(systemName: "camera")}
        
        return Image(uiImage: inputImage)
        
    }
    
    func submitChanges(){
        
        var path:String = ""
        
        if let inputImage = inputImage{
            if let data = inputImage.pngData(){
                path = "\(user.userID)/profile_images/\(Date().timeIntervalSinceReferenceDate)"
                Session.shared.uploadImage(path: path, data: data) { (metadata, err) in
                    if let err = err{
                        self.viewRouter.presentAlert(alert: NativeAlert(alert:  "Something Went Wrong", message: "Check your connection and try again", tip: nil, option1: ("Okay",nil), option2: nil))
                        print(err)
                    }
                    else{
                        let updatedUser = UserSubmission(userID: user.userID, fullName: self.fullName, email: self.email, mobile: self.mobile, imageRef: path, sellerBio: self.sellerBio)
                        
                        self.submitUser(sub: updatedUser)
                    }
                }
            }
        }
        else{
            let updatedUser = UserSubmission(userID: user.userID, fullName: self.fullName, email: self.email, mobile: self.mobile, imageRef: "", sellerBio: self.sellerBio)
            self.submitUser(sub: updatedUser)
        }
    }
    
    func submitUser(sub:UserSubmission){
        Session.shared.userServices.updateUser(userSub: sub) { (err) in
            if let err = err {
                self.viewRouter.presentAlert(alert: NativeAlert(alert:  "Something Went Wrong", message: "Check your connection and try again", tip: nil, option1: ("Okay",nil), option2: nil))
                print(err)
            }
            else{
                Session.shared.userServices.reloadLocalUser()
                self.dismissModal()
            }
        }
    }
    
    func dismissModal(){
        self.viewRouter.dismissModal()
    }
    
}

/*
struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile()
    }
}
*/
