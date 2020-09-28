//
//  ResultDetail.swift
//  Borro
//
//  Created by Miles Broomfield on 07/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct ResultDetail: View {
    
    @EnvironmentObject var viewRouter:ViewRouter
    
    @State var alertIsShown:Bool = false
    
    @State var item:Item
    @State var seller:User?
    
    @State var isLocalUserItem:Bool
    
    @State private var modalIsVisible:Bool = false
    @State private var modalContent:AnyView = AnyView(EmptyView())
    
    @State var stock:Int = 1
    @State var distanceKm:Float = 0
    
    var body: some View {
        ZStack{
        ScrollView(showsIndicators: false){
            imageSection()
            VStack{
                VStack(alignment:.leading,spacing:20){
                    HStack{
                        Text("Top Rated seller:")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color("Teal"))
                        sellerTag(isLocalUserItem: Session.shared.userServices.userIsLocal(userID: item.sellerID))
                        Spacer()
                    }
                    VStack(alignment:.leading,spacing:10){
                        VStack(alignment:.leading){
                            Text("\(item.title)")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("\(item.category)")
                                .font(.headline)
                                .fontWeight(.light)
                        }
                        VStack(alignment:.leading,spacing: 5){
                            HStack{
                                Image(systemName:"mappin.and.ellipse")
                                    .resizable()
                                    .frame(width:15,height:15)
                                    .foregroundColor(Color("Teal"))
                                Text("0.1 Km Away")
                                    .font(.headline)
                                    .fontWeight(.light)
                                Spacer()
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width:15,height:15)
                                    .foregroundColor(Color("Teal"))
                                Text("4.4")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                .foregroundColor(Color("Teal"))
                                Text("(500+ Reviews)")
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color("Teal"))
                            }
                        }
                        
                        HStack{
                            Text("From £\(String(format:"%.2f",item.dailyPrice)) a day")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                    }
                }
                
                borrowButton()
                
                VStack(alignment:.leading,spacing: 10){
                    HStack{
                        Text("Condition: ")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("\(item.condition)")
                            .font(.headline)
                            .fontWeight(.light)
                        Spacer()
                    }
                    HStack{
                        Text("Description")
                        .font(.headline)
                        .fontWeight(.bold)
                        Spacer()
                    }
                    Text("\(item.description)")
                        .font(.headline)
                        .fontWeight(.light)
                }
                
                Spacer()
            }
            .padding()
            Spacer()
        }
        .background(Color.white)
        //.navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $alertIsShown) {
            Alert(title: Text("Something Went Wrong"), message: Text("Check your connection or restart and try again"), dismissButton: .default(Text("Okay")))
        }
        }
        .onAppear{
            Session.shared.userServices.getUserByDocumentID(userID: self.item.sellerID) { (result) in
                if let err = result.1{
                    print(err)
                }
                if let user = result.0{
                    self.seller = user
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.vertical)
  
    }
    
    private func imageSection() -> some View{
        let capsuleHeight:CGFloat = 40
        let imageHeight:CGFloat = 250
        return
        VStack{
            ZStack{
                if(!item.images.isEmpty){
                    StorageImage(fullPath: self.item.images[0], cornerRadius: 0, height: imageHeight)
                }
                else{
                    Rectangle()
                        .foregroundColor(Color("lightGray"))
                        .frame(height:imageHeight)
                }
                VStack{
                    Spacer()
                    Button(action:{}){
                        ZStack{
                            Capsule()
                                .foregroundColor(Color("Teal"))
                            Capsule()
                                .strokeBorder(lineWidth: 5)
                                .foregroundColor(Color.white)
                            Text("See All Images")
                                .font(.subheadline)
                                .fontWeight(.light)
                                .foregroundColor(Color.white)
                        }
                            .offset(y:capsuleHeight/2)
                            .frame(width:200,height:capsuleHeight)
                    }
                }
            }
            .frame(height:imageHeight)
            Spacer()
        }
        .frame(height:imageHeight+capsuleHeight)
    }
    
    private func setStockLevel(){
        self.stock = self.item.quantity
    }
    
    private func deleteItemTapped(){
        //ADD PROMPT
        Session.shared.itemServices.deleteItem(itemID: item.itemID) { (err) in
            if let err = err{
                self.alertIsShown = true
                print(err)
            }
        }
    }
    
    private func loadItem(){
        Session.shared.itemServices.getItemByID(itemID: self.item.itemID) { (item, err) in
            if let err = err{
                print(err)
            }
            if let item = item{
                self.item = item
            }
        }
    }
    
    private func editItemTapped(){
        self.dismissModal()
        self.viewRouter.presentModal(modalContent: AnyView(ItemFunctions(itemFunction: ItemFunctions.ItemFunction.edit, dismissModal: self.dismissModal,item: self.item, user: nil)))
    }
    
    private func borrowTapped(){
        self.dismissModal()
        self.viewRouter.presentModal(modalContent: AnyView(borrowItemModal()))
    }
    
    private func dismissModal(){
        self.viewRouter.dismissModal()
        self.loadItem()
    }
    
    
    private func borrowItemModal() -> some View{
        return
        VStack{
            HStack{
                Spacer()
                Button(action:{self.dismissModal()}){
                    Text("Borrow Dismiss")
                }
            }
            Spacer()
        }
    }
    
    private func borrowButton() -> some View{
        
        var buttonColor = Color("Gray")
        
        if(stock > 0){
            buttonColor = Color("Teal")
        }
        else{
            buttonColor = Color("Gray")
        }
        
        if(isLocalUserItem){
            return
                Button(action:{self.editItemTapped()}){
                Rectangle()
                    .foregroundColor(Color.white)
                    .frame(height:60)
                    .padding(.vertical)
                    .overlay(Text("Edit Item").font(.headline).fontWeight(.bold).foregroundColor(Color("Teal")))
            }
        }
        else{
            if(self.stock > 0){
                return
                    Button(action:{self.borrowTapped()}){
                    Rectangle()
                        .foregroundColor(Color("Teal"))
                        .frame(height:60)
                        .padding(.vertical)
                        .overlay(Text("Borrow Item").font(.headline).fontWeight(.bold).foregroundColor(Color.white))
                }
            }
            else{
                return
                    Button(action:{}){
                    Rectangle()
                        .foregroundColor(Color("Gray"))
                        .frame(height:60)
                        .padding(.vertical)
                        .overlay(Text("Unavailable").font(.headline).fontWeight(.bold).foregroundColor(Color.white))
                }
            }
        }
    }
    
    private func sellerTag(isLocalUserItem:Bool) -> some View{
        
        var anyView:AnyView = AnyView(EmptyView())
        
        if(seller != nil){
            //Is local User
            if(isLocalUserItem){
                anyView =
                AnyView(
                Button(action:{self.viewRouter.setNewTab(view: 1)}){
                    Text("\(seller!.fullName) (Me)")
                        .font(.subheadline)
                        .underline()
                        .fontWeight(.light)
                        .foregroundColor(Color.black)
                }
                )
            }
            else{
                anyView =
                AnyView(
                NavigationLink(destination: RootProfileView(userID: item.sellerID)) {
                    Text("\(seller!.fullName)")
                    .font(.subheadline)
                    .underline()
                    .fontWeight(.light)
                    .foregroundColor(Color.black)
                }
                )
            }
        }
        else{
            anyView =
            AnyView(
            Button(action:{}){
                Text("Unknown")
                    .font(.subheadline)
                    .underline()
                    .fontWeight(.light)
                    .foregroundColor(Color.black)
            }
            )
        }
        
        return anyView
    }
    
    private func stockStatus() -> Text{
        
        if(stock > 0){
            return
            Text("In Stock")
                .foregroundColor(Color("Teal"))
                .font(.subheadline)
                .fontWeight(.bold)
        }
        else{
            return
            Text("Out of Stock")
                .foregroundColor(Color.red)
                .font(.subheadline)
                .fontWeight(.bold)
        }
    }
    
    private func distanceText() -> Text{
        
        let string = distanceKm.description
        
        return
            Text("\(string) Km Away")
            .font(.body)
            .fontWeight(.thin)
        
        
    }
    
}

struct ResultDetail_Previews: PreviewProvider {
    static var previews: some View {
        //ResultDetail.EditItemModal(item: DummyData.items[0])
        ResultDetail(item: DummyData.items[1], isLocalUserItem: false)
    }
}
