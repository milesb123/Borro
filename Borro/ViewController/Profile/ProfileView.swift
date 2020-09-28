//
//  ProfileView.swift
//  Borro
//
//  Created by Miles Broomfield on 08/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var viewRouter:ViewRouter
    
    @State var currentView = 0
    @State var isLocalUser:Bool
    
    @State var user:User
    @State var items:[Item] = []
    
    var body: some View{
        VStack{
            if(user != nil){
            VStack{
                ZStack{
                    VStack{
                        Spacer()
                        Color.white.frame(height:1).shadow(radius: 5)
                    }
                    VStack{
                        Spacer()
                            .frame(height:20)
                        HStack{
                            Spacer()
                            self.viewTab(thisView: 0, text: "Store")
                            Spacer()
                            if(isLocalUser){
                                self.viewTab(thisView: 1, text: "Activity")
                                Spacer()
                            }
                            self.viewTab(thisView: 2, text: "Reviews")
                            Spacer()
                            if(isLocalUser){
                                self.viewTab(thisView: 3, text: "Favourites")
                                Spacer()
                            }
                        }
                        .padding(.vertical)
                    }
                    .background(Color.white)
                }
                .frame(height:60)
                VStack{
                    if(currentView == 0){
                        ScrollView(showsIndicators: false){
                            VStack(spacing: 20){
                                ZStack{
                                    ZStack{
                                        if(user.image != nil){
                                            StorageImage(fullPath: user.image, width: 180, height: 180)
                                                .clipShape(Circle())
                                                // Replace second unwrap with uiimage loaded from assets, as this unwrap is unsafe
                                                .onAppear{
                                                    print("loaded from image data")
                                                }
                                        }
                                        else{
                                            Image(systemName: "person.crop.circle.fill") //Default picture needed
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                                .foregroundColor(Color("lightGray"))
                                                .frame(width:180,height:180)
                                        }
                                        if(isLocalUser){
                                            VStack{
                                                Spacer()
                                                HStack{
                                                    Spacer()
                                                    Button(action:{self.editProfileTapped()}){
                                                        ZStack{
                                                            Circle()
                                                                .foregroundColor(Color.white)
                                                                .shadow(radius: 2)
                                                            Image(systemName:"pencil.circle.fill")
                                                                .resizable()
                                                                .foregroundColor(Color("Teal"))
                                                        }
                                                        .frame(width:40,height:40)
                                                        //.offset(x: 5, y: 5)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .frame(width:180,height:180)
                                    VStack{
                                        HStack{
                                            Spacer()
                                            Button(action:{}){
                                                Image(systemName:"gear")
                                                    .resizable()
                                                    .foregroundColor(Color.black)
                                                    .frame(width:40,height:40)
                                            }
                                            
                                        }
                                        Spacer()
                                    }
                                }
                                
                                VStack(spacing:10){
                                    Text("\(self.user.fullName)")
                                        .foregroundColor(Color.black)
                                        .fontWeight(.bold)
                                        .font(.title)
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text("\(self.user.sellerBio)")
                                        .foregroundColor(Color.black)
                                        .fontWeight(.light)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                    HStack{
                                        Text("Top Rated Seller |")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("Teal"))
                                        Text("4.4 (500+ Reviews)")
                                            .font(.headline)
                                            .fontWeight(.light)
                                            .foregroundColor(Color("Teal"))
                                    }
                                }
                                
                                
                                VStack{
                                    if(isLocalUser){
                                        HStack{
                                            Text("My Items")
                                                .font(.title)
                                                .fontWeight(.bold)
                                            Spacer()
                                            Button(action:{self.addItemTapped()}){
                                                ZStack{
                                                    Circle()
                                                        .foregroundColor(Color("Teal"))
                                                        .shadow(radius: 2)
                                                        
                                                    Image(systemName: "plus")
                                                        .resizable()
                                                        .foregroundColor(Color.white)
                                                        .frame(width:20,height:20)
                                                }
                                                .frame(width:40,height:40)
                                            }
                                        }
                                    }
                                    else{
                                        HStack{
                                            Text("All Items")
                                                .font(.title)
                                                .fontWeight(.bold)
                                            Spacer()
                                        }
                                    }
                                }
                                
                                
                                ForEach(items, id: \.itemID){result in
                                    self.itemPreviewBar(item:result)
                                }
                                
                                Spacer()
                            }
                            .padding(.top)
                        }
                    }
                    else if(currentView == 1){
                        VStack{
                            HStack{
                                Text("Activity")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    else if(currentView == 2){
                        VStack{
                            HStack{
                                Text("Reviews")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    else if(currentView == 2){
                        VStack{
                            HStack{
                                Text("Favourites")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal,20)
            }
            .onAppear{
                self.loadItems()
            }
            }
            else{
                Text("Profile not yet loaded")
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    func loadItems(){
        Session.shared.itemServices.getItemsByUser(userID: self.user.userID) { optionalItems,err in
            if let err = err{
                print(err)
            }
            if let items = optionalItems{
                self.items = items
            }
        }
    }
    
    
    func dismissModal(){
        self.viewRouter.dismissModal()
        self.loadItems()
    }
    
    func addItemTapped(){
        self.viewRouter.presentModal( modalContent: AnyView(ItemFunctions(itemFunction: ItemFunctions.ItemFunction.create, dismissModal: self.dismissModal, item: nil, user: self.user)))
    }
    
    func editProfileTapped(){
        self.viewRouter.dismissModal()
        self.viewRouter.presentModal(modalContent: AnyView(EditProfile(user: $user)))
    }
    
    func viewTab(thisView:Int,text:String) -> some View{
        
        var foreground:Color = Color("Gray")
        var textColor:Color = Color.gray
        
        if(currentView == thisView){
            foreground = Color("Teal")
            textColor = Color.black
        }
        
        return
        Button(action:{self.tabSelected(thisView: thisView)}){
           Text(text)
            .foregroundColor(textColor)
            .font(.subheadline)
            .fontWeight(.light)
            //.underline()
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut)
    }
    
    func tabSelected(thisView:Int){
        self.currentView = thisView
    }
    
    func itemPreviewBar(item:Item) -> some View{
        return
            NavigationLink(destination: ResultDetail(item: item, isLocalUserItem: isLocalUser)){
                HStack(spacing: 20){
                    if(!item.images.isEmpty){
                        StorageImage(fullPath: item.images[0], cornerRadius: 0, width: 60, height: 60)
                    }
                    else{
                        Rectangle()
                            .foregroundColor(Color("lightGray"))
                            .frame(width:60,height:60)
                    }
                    VStack(alignment: .leading){
                        Group{
                            Text("\(item.title)")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("\(item.category)")
                                .font(.subheadline)
                                .fontWeight(.light)
                        }
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    Spacer()
                }
            .buttonStyle(PlainButtonStyle())
        }
        .buttonStyle(PlainButtonStyle())
    }
        
}

struct RootProfileView: View {
    
    @EnvironmentObject var viewRouter:ViewRouter
    
    let userID:String
    
    @State var pendingUser:User?

    var body: some View {
        VStack{
            if(Session.shared.localUser != nil){
                if(Session.shared.userServices.userIsLocal(userID: userID)){
                    if(viewRouter.currentTab == 1){
                        NavigationView{
                            pendingProfileView()
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                        }
                        .padding(0)
                    }
                    else{
                        switchTabView()
                    }
                }
                else{
                    pendingProfileView()
                }
            }
            else{
                Text("User not logged in")
            }
        }
        .onAppear{
            Session.shared.userServices.getUserByDocumentID(userID: self.userID) { (result) in
                if let err = result.1{
                    print(err)
                }
                if let user = result.0{
                    self.pendingUser = user
                }
            }
        }
    }
    
    func switchTabView() -> some View {

        return Text("Move to your profile")
    }
    
    func pendingProfileView() -> AnyView{
        if let user = self.pendingUser{
            return AnyView(ProfileView(isLocalUser: Session.shared.userServices.userIsLocal(userID: user.userID), user: user))
        }
        else{
            //Profile not yet loaded
            return AnyView(Text("Loading"))
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLocalUser: true, user: DummyData.users[1])
    }
}
