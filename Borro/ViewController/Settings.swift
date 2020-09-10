//
//  Settings.swift
//  Borro
//
//  Created by Miles Broomfield on 08/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct Settings: View {
    
    @EnvironmentObject var viewRouter:ViewRouter

    var body: some View {
        VStack{
            HStack{
                Button(action:{self.backButtonTapped()}){
                    Text("Back")
                        .fontWeight(.thin)
                        .underline()
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            ScrollView{
                VStack{
                    Button(action:{self.signOutButtonTapped()}){
                        Capsule()
                            .foregroundColor(Color("Teal"))
                            .frame(width:150,height:60)
                            .overlay(Text("Log In").font(.headline).fontWeight(.bold).foregroundColor(Color.white))
                    }
                    HStack{
                        Text("Personal Information")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    Spacer()
                        .frame(height:200)
                    HStack{
                        Text("Preferences")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    Spacer()
                        .frame(height:200)
                }
            }
        }
        .padding(.horizontal)
    }
    
    func signOutButtonTapped(){
        Session.shared.signOut()
    }
    
    func backButtonTapped(){
        self.viewRouter.setNewTab(view: self.viewRouter.lastTab)
    }
}

struct Settings_Previews: PreviewProvider {
    
    static var previews: some View {
        ScrollView{
            VStack{
                ZStack{
                    Circle()
                        .foregroundColor(Color.gray)
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            ZStack{
                                Circle()
                                    .foregroundColor(Color.white)
                                Image(systemName:"pencil.circle.fill")
                                    .resizable()
                                    .foregroundColor(Color("Teal"))
                            }
                            .frame(width:50,height:50)
                            .offset(x: 5, y: 5)
                        }
                    }
                }
                .frame(width:150,height:150)
                
                VStack(spacing:20){
                    Text("Have a look my stuff, I mainly sell cameras, feel free to ask me any questions")
                        .foregroundColor(Color.black)
                        .fontWeight(.thin)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        
                    HStack{
                        Button(action:{}){
                            Text("Edit Bio")
                                .underline()
                                .fontWeight(.thin)
                        }
                        Spacer()
                    }
                    .foregroundColor(Color.black)
                }
                .padding(.vertical)
                
                VStack{
                    HStack{
                        Text("Personal Information")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    Spacer()
                        .frame(height:200)
                    HStack{
                        Text("Preferences")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    Spacer()
                        .frame(height:200)
                }
            }
            .padding(.horizontal)
        }
    }
}
