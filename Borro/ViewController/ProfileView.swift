//
//  ProfileView.swift
//  Borro
//
//  Created by Miles Broomfield on 08/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @State var currentView = 0
    @State var isLocalUser:Bool
    
    @State var modalIsVisible:Bool = false
    @State var modalContent:AnyView = AnyView(EmptyView())
    
    @State var user:User
    @State var items:[Item] = []
    
    //Alert
    
    @State var alertMessage:String = ""
    @State var alertIsShown:Bool = false
    
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
                                            Image(uiImage: user.image!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                                .frame(width:180,height:180)
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
            .sheet(isPresented: $modalIsVisible) {self.modalContent}
            .onAppear{
                self.loadItems()
            }
            }
            else{
                Text("Profile not yet loaded")
            }
        }
        .alert(isPresented: $alertIsShown) {
            Alert(title: Text("Something Went Wrong"), message: Text("Check your connection or restart and try again"), dismissButton: .default(Text("Okay")))
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    func loadItems(){
        Session.shared.getItemsByUser(userID: self.user.userID) { (optionalItems) in
            if let items = optionalItems{
                self.items = items
            }
            else{
                print("There was a problem loading items")
            }
        }
    }
    
    func presentModal(){
        modalIsVisible = true
    }
    
    func dismissModal(){
        modalIsVisible = false
        modalContent = AnyView(EmptyView())
        self.loadItems()
    }
    
    func addItemTapped(){
        self.dismissModal()
        self.modalContent = AnyView(ItemFunctionsModal(itemFunction: ItemFunctionsModal.ItemFunction.create, dismissModal: self.dismissModal, alertIsShown: $alertIsShown, modalIsVisible: $modalIsVisible, modalContent: $modalContent, item: nil, user: self.user))
        self.presentModal()
    }
    
    func editProfileTapped(){
        self.dismissModal()
        self.modalContent = AnyView(EditProfileModal(alertShown: $alertIsShown, user: $user, modalIsVisible: $modalIsVisible, modalContent: $modalContent))
        self.presentModal()
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
                        StorageImage(fullPath: item.images[0], placeholder: Image(systemName: "camera"), cornerRadius: 0, width: 60, height: 60)
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
    
    struct EditProfileModal:View{
        
        @Binding var alertShown:Bool
        
        @Binding var user:User
        
        @Binding var modalIsVisible:Bool
        @Binding var modalContent:AnyView
        
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
                        Button(action:{self.dismissModal()}){Image(systemName:"xmark.circle.fill").resizable().frame(width:40,height:40).foregroundColor(Color("Teal"))}
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
                            if(user.image != nil){
                                Image(uiImage: user.image!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .frame(width:180,height:180)
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
                                    Button(action:{}){
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
        }
        
        func submitChanges(){
            let updatedUser = UserSubmission(userID: user.userID, fullName: self.fullName, email: self.email, mobile: self.mobile, imageRef: "", sellerBio: self.sellerBio)
            
            Session.shared.updateUser(userSub: updatedUser) { (err) in
                if let err = err {
                    print(err)
                    self.alertShown = true
                }
                else{
                    Session.shared.reloadLocalUser()
                    self.dismissModal()
                }
            }
            
        }
        
        func dismissModal(){
            self.modalIsVisible = false
            self.modalContent = AnyView(EmptyView())
        }
        
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLocalUser: true, user: DummyData.users[1])
    }
}

struct RootProfileView: View {
    
    @EnvironmentObject var viewRouter:ViewRouter
    
    let userID:String
    
    @State var pendingUser:User?

    var body: some View {
        VStack{
            /*
            if(isLocalUser){
                NavigationView{
                    ProfileView(isLocalUser: isLocalUser, user: user)
                }
            }
            else{
                ProfileView(isLocalUser: isLocalUser, user: user)
            }
             */
            if(Session.shared.localUser != nil){
                if(Session.shared.userIsLocal(userID: userID)){
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
            Session.shared.getUserByDocumentID(userID: self.userID) { (user) in
                self.pendingUser = user
            }
        }
    }
    
    func switchTabView() -> some View {

        return Text("Move to your profile")
    }
    
    func pendingProfileView() -> AnyView{
        if let user = self.pendingUser{
            return AnyView(ProfileView(isLocalUser: Session.shared.userIsLocal(userID: user.userID), user: user))
        }
        else{
            //Profile not yet loaded
            return AnyView(Text("Loading"))
        }
    }
}
