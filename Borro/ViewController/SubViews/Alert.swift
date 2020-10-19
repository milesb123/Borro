//
//  Alert.swift
//  Borro
//
//  Created by Miles Broomfield on 13/09/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct AlertView:View{
    
    @EnvironmentObject var viewRouter:ViewRouter
    
    var body: some View{
        GeometryReader{ geometry in
            VStack{
                if(self.viewRouter.alertShown && (self.viewRouter.alertContent != nil)){
                    Spacer()
                    HStack{
                        Spacer()
                        self.viewRouter.alertContent!
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct NativeAlert: View {
    
    @EnvironmentObject var viewRouter:ViewRouter
    
    let alert:String
    
    let message:String
    
    let tip:String?
    
    let warning:String?
    
    let option1:(String,(()->Void)?)
    
    let option2:(String,(()->Void)?)?
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color.white)
                .shadow(radius: 5)
            VStack{
                Text(self.alert)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                VStack(alignment:.center ,spacing:10){
                    Text(self.message)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                    if(self.tip != nil){
                        Text("Tip: \(tip!)")
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundColor(Color("Teal"))
                    }
                    if(self.warning != nil){
                        Text("Warning: \(warning!)")
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundColor(Color.red)
                    }
                }
                .padding(.bottom)
                Spacer()
                HStack(spacing:30){
                    button(text: option1.0, action: self.function1)
                    if(option2 != nil){
                        button(text: option2!.0, action: self.function2)
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth:300,maxHeight:200)
            
    }
    
    func button(text:String,action:@escaping ()->Void) -> some View{
        return
        Button(action:{action()}){
            Capsule()
                .foregroundColor(Color("Teal"))
                .frame(width:80,height:30)
                .overlay(Text(text).font(.caption).fontWeight(.bold).foregroundColor(Color.white))
        }
    }
    
    
    func function1(){
        if let fopt1 = self.option1.1{
            fopt1()
        }
        self.dismissModal()
    }
    
    func function2(){
        if let opt2 = self.option2{
            if let fopt2 = opt2.1{
                fopt2()
            }
            self.dismissModal()
        }
    }
    
    func dismissModal(){
        self.viewRouter.alertShown = false
    }
    
}

