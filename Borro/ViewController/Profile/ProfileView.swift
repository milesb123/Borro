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
                VStack(spacing:0){
                if(self.isLocalUser){
                    HStack{
                        Text("Borro.")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("Teal"))
                            .padding()
                    }
                    .frame(width:UIScreen.main.bounds.width)
                    .background(ZStack{VStack{Spacer();Color.white.shadow(radius: 2).frame(height:1)};Color.white})
                    .overlay(
                        HStack{
                            Button(action:{}){
                            Spacer()
                            Image(systemName:"gear")
                                .resizable()
                                .foregroundColor(Color("Teal"))
                                .frame(width:30,height:30)
                            }
                            .padding()
                        }
                    )
                }
                
                VStack{
                    if(currentView == 0){
                        StoreView(loadItems:self.loadItems,isLocalUser:self.$isLocalUser,user:self.$user,items:self.$items)
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
                .padding(.horizontal)
            }
            .onAppear{
                self.loadItems()
            }
            }
            else{
                Text("Profile not yet loaded")
            }
        }
        .navigationBarTitle(Text(self.user.fullName),displayMode: .inline)
        .navigationBarHidden(false)
        //.edgesIgnoringSafeArea(.vertical)
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
    }
    
    func tabSelected(thisView:Int){
        self.currentView = thisView
    }
    
    func loadItems() -> Void{
        Session.shared.itemServices.getItemsByUser(userID: self.user.userID) { optionalItems,err in
            if let err = err{
                print(err)
            }
            if let items = optionalItems{
                self.items = items
            }
        }
    }
    
    struct StoreView:View{
        
        let loadItems:()->Void
        
        @EnvironmentObject var viewRouter:ViewRouter
        
        @Binding var isLocalUser:Bool
        
        @Binding var user:User
        @Binding var items:[Item]
        
        var body:some View{
            ScrollView(showsIndicators: false){
                VStack(spacing: 20){
                    //Image Section
                    ZStack{
                        if(false){
                            StorageImage(fullPath: user.image, width: 180, height: 180)
                                .clipShape(Circle())
                                .onAppear{
                                    print("loaded from image data")
                                }
                        }
                        else{
                            Image(systemName: "person.crop.circle.fill")
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
                                    Button(action:{editProfileTapped()}){
                                        ZStack{
                                            Circle()
                                                .foregroundColor(Color.white)
                                                .shadow(radius: 2)
                                            Image(systemName:"pencil.circle.fill")
                                                .resizable()
                                                .foregroundColor(Color("Teal"))
                                        }
                                        .frame(width:40,height:40)
                                    }
                                }
                            }
                        }
                    }
                    .frame(width:180,height:180)
                    .padding(.top)
                    
                    //User Details Section
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
                    }
                    
                    //Items
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
        
        func itemPreviewBar(item:Item) -> some View{
            return
                NavigationLink(destination: ResultDetail(item: item, isLocalUserItem: isLocalUser)){
                    HStack(spacing: 20){
                        if(false){
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
                                Text("\(item.categories[0])")
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
                        .accentColor(Color("Teal"))
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
