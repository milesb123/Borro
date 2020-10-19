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
    @State var currentContainerView:AnyView = AnyView(EmptyView())

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack(spacing:0){
                    
                    if(self.localUser != nil){
                        VStack(spacing:0){
                            //Content
                            VStack{
                                self.currentContainerView
                            }
                        
                            //Navigation Bar
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
                .onReceive(Session.shared.$localUser) { (user) in
                    self.localUser = user
                }
                
                //Modal
                Modal()
                
                //Menu
                SlidingMenu(publisher: viewRouter.menuPublisher, view: AnyView(VStack{HStack{Spacer()};Spacer()}))
                    .edgesIgnoringSafeArea(.top)
                
                //Alert
                AlertView()
            }
            .onReceive(self.viewRouter.$currentTab, perform: { tab in
                if(tab == 0){
                    self.currentContainerView = AnyView(self.rootSearchView())
                }
                else if(tab == 1){
                    self.currentContainerView = AnyView(self.rootProfileView())
                }
            })
        }
    }
    
    func rootSearchView() -> some View{
        
        return
        NavigationView{
            RootSearchView()
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
        .accentColor(Color("Teal"))
    }
    
    func rootProfileView() -> some View{
        return RootProfileView(userID: self.localUser!.userID)
        
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
