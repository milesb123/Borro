//
//  MotherView.swift
//  Borro
//
//  Created by Miles Broomfield on 08/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct MotherView: View {
    
    @EnvironmentObject var viewRouter:ViewRouter
    @State var navBarHidden = true
    @State var localUser:User?

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack(spacing:0){
                    if(self.localUser != nil){
                        VStack(spacing:0){
                            //Content
                            VStack{
                                if(self.viewRouter.currentTab == 0){
                                    NavigationView{
                                        RootSearchView()
                                            .navigationBarTitle("")
                                            .navigationBarHidden(true)
                                    }
                                }
                                else if(self.viewRouter.currentTab == 1){
                                    RootProfileView(userID: self.localUser!.userID)
                                }
                        }
                        //Spacer()
                        VStack(spacing:0){
                            HStack(spacing:10){
                                Spacer()
                                self.viewTab(thisView: 0)
                                Spacer()
                                self.viewTab(thisView: 1)
                                Spacer()
                                    
                            }
                            .padding(.vertical)
                            .padding(.bottom)
                        }
                        .frame(width: geometry.size.width,height:geometry.size.height/10)
                        .foregroundColor(Color.white)
                        .background(Color.white.shadow(radius: 2))
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    }
                    else{
                        LoginView()
                    }
                }
                .onAppear{
                    self.localUser = Session.shared.localUser
                }
                .onReceive(Session.shared.$localUser) { (user) in
                    self.localUser = user
                }
                
                Modal()
                
                if(self.viewRouter.alertShown){
                    self.viewRouter.alert
                    onAppear{
                        print("Alert appeared")
                    }
                }
            }
        }
    }
    
    func viewTab(thisView:Int) -> some View{
        
        var image:String = ""
        var tabColor:Color = Color.gray
        
        if(thisView == self.viewRouter.currentTab){
            tabColor = Color.black
        }
        
        if(thisView == 0){
            image = "magnifyingglass"
        }
        else if (thisView == 1){
            image = "person.crop.circle"
        }
        
        return
            Button(action:{self.tabSelected(thisView: thisView)}){
            Image(systemName: image)
                .resizable()
                //.aspectRatio(contentMode: .fit)
                .padding()
                .frame(width: 65,height: 65)
                .foregroundColor(tabColor)
            }
        
    }
    
    func tabSelected(thisView:Int){
        if(thisView == 0){
            self.searchIconTapped()
        }
        else if(thisView == 1){
            self.profileIconTapped()
        }
    }
    
    func searchIconTapped(){
        self.viewRouter.setNewTab(view: 0)
    }
    
    func profileIconTapped(){
        self.viewRouter.setNewTab(view: 1)
    }
    
    func settingsTapped(){
        /*
        self.viewRouter.setNewTab(view: 2)
        */
        Session.shared.userServices.signOut()
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
