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
            Spacer()
                .frame(height:UIScreen.main.bounds.height*0.12)
            VStack(spacing: 20){
                HStack{
                    Text(item.title)
                        .font(.title)
                        .bold()
                    Spacer()
                }
                
                imageSection()
                
                HStack(alignment:.top){
                    VStack(alignment:.leading){
                        Text(item.category)
                            .font(.caption)
                            .fontWeight(.light)
                            .underline()
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    }
                    Spacer()
                    HStack{
                        Image(systemName: "person.fill")
                            .foregroundColor(Color("Teal"))
                        self.sellerTag(isLocalUserItem: Session.shared.userServices.userIsLocal(userID: item.sellerID))
                    }
                }
                
                HStack{
                    Text("From £\(String(format:"%2.f",item.dailyPrice)) / day")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                borrowButton()
                
                VStack(alignment:.leading,spacing:10){
                    
                    Text("Description")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text(item.description)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    HStack{
                        Spacer()
                    }
                }
                
                Spacer()
            }
            .padding()
            Spacer()
        }
        .background(Color.white)
        
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
        .navigationBarTitle(Text(item.title),displayMode: .inline)
        .navigationBarHidden(false)
        .edgesIgnoringSafeArea(.vertical)
    }
    
    private func imageSection() -> some View{
        ZStack{
            Rectangle()
                .foregroundColor(Color("lightGray"))
            VStack{
                Spacer()
                Button(action:{}){
                    Rectangle()
                        .foregroundColor(Color("Teal"))
                        .frame(width:150,height:30)
                        .overlay(Text("See All").font(.caption).fontWeight(.light).foregroundColor(Color.white))
                }
            }
            .padding()
        }
        .frame(height:200)
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
                    .foregroundColor(Color("Teal"))
                    .frame(height:60)
                    .overlay(Text("Edit Item").font(.headline).fontWeight(.bold).foregroundColor(Color.white))
            }
        }
        else{
            if(self.stock > 0){
                return
                    Button(action:{self.borrowTapped()}){
                    Rectangle()
                        .foregroundColor(Color("Teal"))
                        .frame(height:60)
                        .overlay(Text("Borrow Now").font(.headline).fontWeight(.bold).foregroundColor(Color.white))
                }
            }
            else{
                return
                    Button(action:{}){
                    Rectangle()
                        .foregroundColor(Color("Gray"))
                        .frame(height:60)
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
                        .font(.caption)
                        .fontWeight(.light)
                        .underline()
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
                .buttonStyle(PlainButtonStyle())
                )
            }
            else{
                anyView =
                AnyView(
                NavigationLink(destination: RootProfileView(userID: item.sellerID)) {
                    Text("\(seller!.fullName)")
                        .font(.caption)
                        .fontWeight(.light)
                        .underline()
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
                .buttonStyle(PlainButtonStyle())
                )
            }
        }
        else{
            anyView =
            AnyView(
            Button(action:{}){
                Text("Unknown")
                    .font(.caption)
                    .fontWeight(.light)
                    .underline()
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            }
            .buttonStyle(PlainButtonStyle())
            )
        }
        
        return anyView
    }
    
}

struct ResultDetail_Previews: PreviewProvider {
    static var previews: some View {
        //ResultDetail.EditItemModal(item: DummyData.items[0])
        ResultDetail(item: DummyData.items[1], isLocalUserItem: false)
    }
}
