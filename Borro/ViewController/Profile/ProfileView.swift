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
                            Button(action:{self.viewRouter.menuPublisher.presentMenu()}){
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
                        .padding(.horizontal,20)
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
                        .padding(.horizontal,20)
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
                        .padding(.horizontal,20)
                    }
                }
                //.padding(.horizontal)
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
                }
                .padding(.horizontal,20)
                
                VStack(spacing:10){
                    ForEach(items, id: \.itemID){result in
                        ItemRow(item: result, isLocalUser: $isLocalUser, loadItems: self.loadItems, deleteItem: self.deleteItem)
                    }
                }
                .padding(.top)
                
                Spacer()
                
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
        
        func deleteItem(item:Item) -> Void{
            Session.shared.itemServices.deleteItem(itemID: item.itemID) { (err) in
                if let err = err{
                    print(err)
                }
            }
        }
    }
    
    struct ItemRow:View{
        
        @EnvironmentObject var viewRouter:ViewRouter
        
        let barHeight:CGFloat = 80
        
        let iconWidth:CGFloat = 25
        let horizontalPadding:CGFloat = 20
        
        let item:Item
        
        @Binding var isLocalUser:Bool
        
        @State var size: CGFloat = 0
        
        //delete shown -> hPadding  + iWidth + hPadding
        let presentedOffset:CGFloat = -(20+25+20)
        //delete hidden
        let hiddenOffset:CGFloat = 0
        let sufficientGesture:CGFloat = 50
        
        let loadItems:()->Void
        let deleteItem:(Item)->Void

        var body: some View{
            ZStack{
                bottom()
                top()
                .offset(x:size)
                .highPriorityGesture(DragGesture().onChanged({(value) in
                    //moved right if menu is not already expanded
                    if value.translation.width > 0 && !(self.size>=presentedOffset){
                        self.size = value.translation.width
                    }
                    //moved left
                    else if value.translation.width<0{
                        self.size = hiddenOffset + value.translation.width
                    }
                })
                .onEnded({ (value) in
                    
                    //moved right
                    if value.translation.width > 0{
                        //Sufficient gesture
                        if value.translation.width > sufficientGesture{
                            //trigger alert
                            //Can Present
                            self.size = hiddenOffset
                        }
                        //Insufficient Gesture
                        else{
                            //Remain in Position
                            self.size = presentedOffset
                        }
                    }
                    //moved left
                    else{
                        //Sufficient gesture
                        if -value.translation.width > sufficientGesture{
                            //Can Show Delete
                            self.size = presentedOffset
                            self.deletePresented()

                        }
                        //Insufficient Gesture
                        else{
                            //Remain in Position
                            self.size = hiddenOffset
                        }
                    }
                    
                })).animation(.spring())
                
            }
            
            .frame(height:barHeight)
        }
        func bottom() -> some View{
                        
            return
            
            HStack{
                VStack{
                    Spacer()
                }
                Spacer()
                Image(systemName: "trash.fill")
                    .resizable()
                    .frame(width:iconWidth,height:iconWidth)
                    .foregroundColor(Color.white)
                    .padding(.horizontal,horizontalPadding)
            }
            .background(Color("Teal"))
        }
        
        func top() -> some View{
            
            return
            NavigationLink(destination: ResultDetail(item: item, isLocalUserItem: isLocalUser)){
                HStack(spacing: 20){
                    //padded layer
                    HStack{
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
                        if(self.size > presentedOffset/2){
                            Image(systemName: "trash.fill")
                                .resizable()
                                .frame(width:iconWidth,height:iconWidth)
                                .foregroundColor(Color("lightGray"))
                                .animation(.linear)
                        }
                    }
                    .padding(.horizontal,horizontalPadding)
                    .padding(.vertical,10)
                }
                .buttonStyle(PlainButtonStyle())
                .background(Color.white)
            }
            .buttonStyle(PlainButtonStyle())
        }
        
        func deletePresented(){
            self.viewRouter.presentAlert(alert: NativeAlert(alert: "Delete Item", message: "Are you sure you want to delete this item?", tip: nil, warning: "This cannot be undone", option1: ("Yes",{self.deleteItem(item);self.hideSlider();self.loadItems()}), option2: ("No",{self.hideSlider()})))
            //self.hideSlider()
        }
        
        func hideSlider()->Void{
            self.size = self.hiddenOffset
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
        ProfileView(isLocalUser: true, user: DummyData.users[0])
        //ProfileView.ItemRow(item: DummyData.items[0], isLocalUser: true)
    }
}
