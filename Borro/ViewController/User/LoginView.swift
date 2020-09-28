//
//  LoginView.swift
//  Borro
//
//  Created by Miles Broomfield on 24/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    //View Controller
    @EnvironmentObject var viewRouter:ViewRouter
    
    //Fields
    @State var email:String = ""
    @State var password:String = ""
    
    @State var errorDisplayed:String?
    @State var disabled:Bool = false
    
    var body: some View {
        GeometryReader{ geometry in
            //Main Container
            VStack{
                //Borro Header
                Rectangle()
                    .foregroundColor(Color("Teal"))
                    .overlay(Text("Borro.").fontWeight(.bold).foregroundColor(Color.white)).font(.system(size: 50))
                    .frame(height: geometry.size.height*0.25)
                
                VStack{
                    //Error Message
                    if(self.errorDisplayed != nil){
                        Text("\(self.errorDisplayed!)")
                            .foregroundColor(Color.red)
                            .font(.subheadline)
                            .fontWeight(.thin)
                    }
                    
                    //Input Fields
                    Group{
                        self.inputField(placeholder: "Email", state: self.$email)
                        self.inputField(placeholder: "Password", state: self.$password)
                        
                    }
                    .padding(.bottom,40)
                    
                    //Login Button
                    Button(action:{self.loginButtonTapped()}){
                        Rectangle()
                            .foregroundColor(Color("Teal"))
                            .frame(height:50)
                            .overlay(Text("Log In").font(.headline).fontWeight(.bold).foregroundColor(Color.white))
                    }
                    
                    
                    VStack(spacing:15){
                        //Create Account Button
                        Button(action:{self.createAccountTapped()}){
                            Text("Create an Account")
                                .foregroundColor(Color.black)
                                .font(.subheadline)
                                .fontWeight(.thin)
                        }
                        .buttonStyle(PlainButtonStyle())
                        //Forgot Password Button
                        Button(action:{self.forgotPasswordTapped()}){
                            Text("Forgot Password?")
                                .foregroundColor(Color.black)
                                .font(.subheadline)
                                .fontWeight(.thin)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical)
                }
                .frame(width:geometry.size.width*0.8)
                .padding(.vertical,40)
                Spacer()
            }
        }
        .disabled(self.disabled)
        .edgesIgnoringSafeArea(.top)
    }

    
    func createAccountTapped(){
        self.viewRouter.presentModal(modalContent: AnyView(CreateUser()))
    }
    
    func forgotPasswordTapped(){
    }
    
    func loginButtonTapped(){
        self.disabled = true
        Session.shared.userServices.signIn(email: self.email, password: self.password) { (error) in
            if let error = error{
                self.errorDisplayed = "Invalid email or password"
                self.disabled = false
            }
            else{
                self.disabled = false
            }
        }
    }
    
    func inputField(placeholder:String, state: Binding<String>) -> some View{
        return
        VStack{
            TextField(placeholder, text: state)
            Rectangle()
                .foregroundColor(Color.black)
                .frame(height: 1)
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
