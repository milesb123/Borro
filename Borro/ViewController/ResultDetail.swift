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
                        sellerTag(isLocalUserItem: Session.shared.userIsLocal(userID: item.sellerID))
                        Spacer()
                    }
                    VStack(alignment:.leading,spacing:10){
                        VStack(alignment:.leading){
                            Text("\(item.title)")
                                .font(.largeTitle)
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
        .sheet(isPresented: $modalIsVisible){self.modalContent}
        .background(Color.white)
        //.navigationBarTitle(Text(item.title).fontWeight(.bold).font(.title),displayMode: .large)
        //.navigationBarHidden(false)
        .alert(isPresented: $alertIsShown) {
            Alert(title: Text("Something Went Wrong"), message: Text("Check your connection or restart and try again"), dismissButton: .default(Text("Okay")))
        }
        }
        .onAppear{
            Session.shared.getUserByDocumentID(userID: self.item.sellerID) { (user) in
                self.seller = user
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
                    StorageImage(fullPath:item.images[0], placeholder: Image(systemName: "rectangle.fill"), cornerRadius: 0, height: imageHeight)
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
        }
        .frame(height:imageHeight+capsuleHeight)
    }
    
    private func setStockLevel(){
        self.stock = self.item.quantity
    }
    
    private func deleteItemTapped(){
        //ADD PROMPT
        Session.shared.deleteItem(itemID: item.itemID) { (err) in
            if let err = err{
                self.alertIsShown = true
                print(err)
            }
        }
    }
    
    private func loadItem(){
        Session.shared.getItemByID(itemID: self.item.itemID) { (item, err) in
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
        self.modalContent = AnyView(ItemFunctionsModal(itemFunction: ItemFunctionsModal.ItemFunction.edit, dismissModal: self.dismissModal, alertIsShown: $alertIsShown, modalIsVisible: self.$modalIsVisible, modalContent: self.$modalContent, item: self.item, user: nil))
        self.presentModal()
    }
    
    private func borrowTapped(){
        self.dismissModal()
        self.modalContent = AnyView(borrowItemModal())
        self.presentModal()
    }
    
    private func presentModal(){
        self.modalIsVisible = true
    }
    
    private func dismissModal(){
        self.modalIsVisible = false
        self.modalContent = AnyView(EmptyView())
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
                    .shadow(radius: 5)
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
                        .shadow(radius: 5)
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
                        .shadow(radius: 5)
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
 
    struct EditItemModal:View{
        
        @Binding var alertIsShown:Bool
        
        @Binding var modalIsVisible:Bool
        @Binding var modalContent:AnyView
        
        @Binding var item:Item
        
        @State var title:String = ""
        @State var titleValid:(Bool,ErrorType?)?
        
        @State var category:String = ""
        @State var categoryValid:(Bool,ErrorType?)?
        
        @State var conditionTag:Int = 0
        let conditions = ["Brand New","Lightly Used","Used"]
        @State var conditionsValid:(Bool,ErrorType?)?
        
        @State var dailyPrice:String = ""
        @State var dailyPriceValid:(Bool,ErrorType?)?
        
        @State var description:String = ""
        @State var descriptionValid:(Bool,ErrorType?)?
        
        @State var quantity:String = ""
        @State var quantityValid:(Bool,ErrorType?)?
        
        @State var pickUpLocation:String = ""
        @State var pickUpLocationValid:(Bool,ErrorType?)?
        
        @State var media:[String] = []
        
        var body: some View{
            VStack{
                HStack{
                    Text("Edit Item")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    Button(action:{self.dismissModal()}){Image(systemName:"xmark.circle.fill").resizable().frame(width:40,height:40).foregroundColor(Color("Teal"))}
                }
                ScrollView{
                    VStack(alignment: .leading,spacing:20){
                        Text("Edit the fields where relevant and tap submit when your’e finished")
                            .font(.headline)
                            .fontWeight(.light)
                        field(title: "Title", placeholderText: "Enter the title of the item", bindingValue: $title, validationBinding: $titleValid,completionHandler: {self.validateField(field: Field.title)})
                        Group{
                            Text("Images")
                                .font(.headline)
                                .fontWeight(.bold)
                            ScrollView(.horizontal, showsIndicators: true){
                                HStack{
                                    ForEach(self.media, id: \.self){path in
                                        StorageImage(fullPath: path, placeholder: Image(systemName: "camera"), cornerRadius: 0, width: 100, height: 100)
                                    }
                                    Button(action:{}){
                                        Rectangle()
                                            .foregroundColor(Color("lightGray"))
                                            .frame(width:100,height:100)
                                            .overlay(Image(systemName:"plus").resizable().frame(width:40,height:40).foregroundColor(Color.white))
                                    }
                                }
                            }
                            Text("Tap the plus icon to add an image or videos (up to 10 items)")
                                .font(.subheadline)
                                .fontWeight(.light)
                                .foregroundColor(Color.gray)
                        }
                        Group{
                            Text("Condtion")
                                .font(.headline)
                                .fontWeight(.bold)
                            Picker(selection: $conditionTag, label: Text("")) {
                                ForEach(0..<self.conditions.count){index in
                                    Text(self.conditions[index]).tag(index)
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                            Text("Select the condition that best fits your item")
                                .font(.subheadline)
                                .fontWeight(.light)
                                .foregroundColor(Color.gray)
                        }
                        field(title: "Category", placeholderText: "Select the category of the item", bindingValue: $category, validationBinding: $categoryValid,completionHandler: {self.validateField(field: Field.category)})
                        field(title: "Daily Price", placeholderText: "Price per day", bindingValue: $dailyPrice, validationBinding: $dailyPriceValid,helperText: "Enter the price it would cost someone to borrow your item per day",keyboardType:.numberPad,currency: "£",completionHandler: {self.validateField(field: Field.dailyPrice)})
                        field(title: "Available Quantity", placeholderText: "Enter quantity", bindingValue: $quantity, validationBinding: $quantityValid,keyboardType: .numberPad){self.validateField(field: Field.availableQuantity)}
                        field(title: "Description", placeholderText: "Enter a description", bindingValue: $description, validationBinding: $descriptionValid, completionHandler: {self.validateField(field: Field.description)})
                        field(title:"Pick Up Location",placeholderText: "Enter pickup location",bindingValue: $pickUpLocation, validationBinding: $pickUpLocationValid,helperText: "Enter the location a customer should pick up the item from, read our safety guidlines here",completionHandler: {self.validateField(field: Field.pickUpLocation)})
                    }
                    Button(action:{self.submitChanges()}){Capsule().frame(width:150,height:50).foregroundColor(Color("Teal")).overlay(Text("Submit").font(.headline).fontWeight(.bold).foregroundColor(Color.white))}.padding()
                        .padding(.vertical)
                    Spacer()
                        .frame(height:UIScreen.main.bounds.height*0.4)
                }
            }
            .padding()
            .onAppear{
                self.title = self.item.title
                self.category = self.item.category
                self.setCondtionPicker(itemCondtion: self.item.condition)
                self.dailyPrice = self.item.dailyPrice.description
                self.description = self.item.description
                self.quantity = self.item.quantity.description
                self.pickUpLocation = self.item.pickUpLocation
            }
        }
        
        func setCondtionPicker(itemCondtion:String){
            self.conditionTag = self.conditions.firstIndex(of: itemCondtion) ?? 2
        }
        
        func field(title:String = "field",placeholderText:String = "Enter field",bindingValue:Binding<String>,validationBinding:Binding<(Bool,ErrorType?)?>,helperText:String?=nil,keyboardType:UIKeyboardType=UIKeyboardType.default,currency:String?=nil,completionHandler:@escaping ()->Void) -> some View{
            
            
            
            return
                VStack(alignment:.leading){
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .font(.subheadline)
                    if(currency != nil){
                        HStack{
                            Text(currency!)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                            TextField(placeholderText, text: bindingValue,onCommit: {
                                completionHandler()
                                print(title)
                                
                            })
                                .font(.subheadline)
                            //.keyboardType(keyboardType)
                        }
                    }
                    else{
                        TextField(placeholderText, text: bindingValue,onCommit: {
                            completionHandler()
                            print(title)
                        })
                            .font(.subheadline)
                        //.keyboardType(keyboardType)
                    }
                    
                    Rectangle()
                        .frame(height:0.5)
                    if (helperText != nil){
                        Text(helperText!)
                            .foregroundColor(Color.gray)
                            .font(.subheadline)
                            .fontWeight(.light)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    if (validationBinding.wrappedValue != nil && validationBinding.wrappedValue!.1 != nil){
                        Text(self.returnErrorMessage(error: validationBinding.wrappedValue!.1!) ?? "")
                            .foregroundColor(Color.red)
                            .font(.subheadline)
                            .fontWeight(.light)
                            .fixedSize(horizontal: false, vertical: true)
                    }
            }
        }
        
        func validateField(field:Field){
            switch(field){
            case Field.title:
                if(self.title.isEmpty){
                    self.titleValid = (false,ErrorType.emptyField)
                }
                else{
                    self.titleValid = (true,nil)
                }
            case Field.condition:
                self.conditionsValid = (true,nil)
            case Field.category:
                if(self.category.isEmpty){
                    self.categoryValid = (false,ErrorType.emptyField)
                }
                else{
                    self.categoryValid = (true,nil)
                }
            case Field.dailyPrice:
                let dailyPrice = Double(self.dailyPrice)
                if(self.dailyPrice.isEmpty){
                    self.dailyPriceValid = (false,ErrorType.emptyField)
                }
                else if (dailyPrice == nil || (dailyPrice != nil && dailyPrice! <= 0)){
                    self.dailyPriceValid = (false,ErrorType.invalidInputRequiresPositiveNumbers)
                }
                else{
                    self.dailyPriceValid = (true,nil)
                }
            case Field.availableQuantity:
                let quantity = Int(self.quantity)
                if(self.quantity.isEmpty){
                    self.quantityValid = (false,ErrorType.emptyField)
                }
                else if (quantity == nil || (quantity != nil && quantity! <= 0)){
                    self.quantityValid = (false,ErrorType.invalidInputRequiresPositiveIntegers)
                }
                    
                else{
                    self.quantityValid = (true,nil)
                }
            case Field.pickUpLocation:
                if(self.pickUpLocation.isEmpty){
                    self.pickUpLocationValid = (false,ErrorType.emptyField)
                }
                else{
                    self.pickUpLocationValid = (true,nil)
                }
                
            case Field.description:
                if(self.description.isEmpty){
                    self.descriptionValid = (false,ErrorType.emptyField)
                }
                else{
                    self.descriptionValid = (true,nil)
                }
            default:
                print("no validation required")
            }
        }
        
        func validateList(list:[Field]){
            for field in list{
                self.validateField(field: field)
            }
        }
        
        func allFieldsValid() -> Bool{
            return
                (self.titleValid != nil && self.titleValid!.0
                    && self.conditionsValid != nil && self.conditionsValid!.0
                    && self.categoryValid != nil && self.categoryValid!.0
                    && self.dailyPriceValid != nil && self.dailyPriceValid!.0
                    && self.quantityValid != nil && self.quantityValid!.0
                    && self.pickUpLocationValid != nil && self.pickUpLocationValid!.0
                    && self.descriptionValid != nil && self.descriptionValid!.0)
            
        }
        
        func submitChanges(){
            self.validateList(list: [Field.title,Field.condition,Field.category,Field.dailyPrice,Field.pickUpLocation,Field.availableQuantity,Field.description])
            
            if(self.allFieldsValid()){
                let updatedItem = Item(itemID: self.item.itemID, sellerID: self.item.sellerID, title: self.title, category: self.category, condition: self.conditions[self.conditionTag], dailyPrice: self.item.dailyPrice, description: self.description, quantity: self.item.quantity, pickUpLocation: self.pickUpLocation)
                //Make Robust!!!!
                Session.shared.updateItem(updatedItem: updatedItem) { (err) in
                    if let err = err{
                        self.alertIsShown = true
                        print(err)
                    }
                    else{
                        self.item = updatedItem
                        self.dismissModal()
                    }
                }
            }
            else{
                print("Errror")
            }
        }
        
        func dismissModal(){
            self.modalIsVisible = false
            self.modalContent = AnyView(EmptyView())
        }
        
        func returnErrorMessage(error:ErrorType)->String?{
            if(error == ErrorType.emptyField){
                return "This field cannot be left empty"
            }
            else if(error == ErrorType.invalidInputRequiresPositiveNumbers){
                return "Invalid input, please enter numbers above 0 only"
            }
            else if(error == ErrorType.invalidInputRequiresPositiveIntegers){
                return "Invalid input, please enter whole numbers above 0 only"
            }
            else{
                return nil
            }
        }
        
        enum Field{
            case title
            case condition
            case category
            case dailyPrice
            case availableQuantity
            case description
            case pickUpLocation
        }
        
        enum ErrorType{
            case emptyField
            case invalidInputRequiresPositiveNumbers
            case invalidInputRequiresPositiveIntegers
        }
        
    }
    
}

struct ItemFunctionsModal:View{
    
    let itemFunction:ItemFunction
    
    let dismissModal:()->Void
    
    @Binding var alertIsShown:Bool
    
    @Binding var modalIsVisible:Bool
    @Binding var modalContent:AnyView
    
    let item:Item?
    let user:User?
    
    @State var title:String = ""
    @State var titleValid:(Bool,ErrorType?)?
    
    @State var category:String = ""
    @State var categoryValid:(Bool,ErrorType?)?
    
    @State var conditionTag:Int = 0
    let conditions = ["Brand New","Lightly Used","Used"]
    @State var conditionsValid:(Bool,ErrorType?)?
    
    @State var dailyPrice:String = ""
    @State var dailyPriceValid:(Bool,ErrorType?)?
    
    @State var description:String = ""
    @State var descriptionValid:(Bool,ErrorType?)?
    
    @State var quantity:String = ""
    @State var quantityValid:(Bool,ErrorType?)?
    
    @State var pickUpLocation:String = ""
    @State var pickUpLocationValid:(Bool,ErrorType?)?
    
    @State var loadedMedia:[String] = []
    
    var body: some View{
        VStack{
            HStack{
                if(itemFunction == ItemFunction.edit){
                    Text("Edit Item")
                        .font(.title)
                        .fontWeight(.bold)
                }
                else if(itemFunction == ItemFunction.create){
                    Text("Add Item")
                    .font(.title)
                    .fontWeight(.bold)
                }
                
                Spacer()
                Button(action:{self.dismissModal()}){Image(systemName:"xmark.circle.fill").resizable().frame(width:40,height:40).foregroundColor(Color("Teal"))}
            }
            ScrollView{
                VStack(alignment: .leading,spacing:20){
                    if(itemFunction == ItemFunction.edit){
                        Text("Edit the fields where relevant and tap submit when your’e finished")
                            .font(.headline)
                            .fontWeight(.light)
                    }
                    else if(itemFunction == ItemFunction.create){
                        Text("Fill in the form and tap submit when your’e finished")
                            .font(.headline)
                            .fontWeight(.light)
                    }
                    field(title: "Title", placeholderText: "Enter the title of the item", bindingValue: $title, validationBinding: $titleValid,completionHandler: {self.validateField(field: Field.title)})
                    Group{
                        Text("Images")
                            .font(.headline)
                            .fontWeight(.bold)
                        ScrollView(.horizontal, showsIndicators: true){
                            HStack{
                                if(itemFunction == ItemFunction.edit){
                                    if(!self.loadedMedia.isEmpty){
                                        ForEach(self.loadedMedia, id: \.self){path in
                                            StorageImage(fullPath: path, placeholder: Image(systemName: "camera"), cornerRadius: 0, width: 100, height: 100)
                                        }
                                    }
                                    else{
                                        Rectangle()
                                            .foregroundColor(Color("lightGray"))
                                            .frame(height: UIScreen.main.bounds.height*0.25)
                                    }
                                }
                                else if(itemFunction == ItemFunction.create){
                                    //data to be uploaded
                                }
                                Button(action:{}){
                                    Rectangle()
                                        .foregroundColor(Color("lightGray"))
                                        .frame(width:100,height:100)
                                        .overlay(Image(systemName:"plus").resizable().frame(width:40,height:40).foregroundColor(Color.white))
                                }
                            }
                        }
                        Text("Tap the plus icon to add an image or videos (up to 10 items)")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(Color.gray)
                    }
                    Group{
                        Text("Condtion")
                            .font(.headline)
                            .fontWeight(.bold)
                        Picker(selection: $conditionTag, label: Text("")) {
                            ForEach(0..<self.conditions.count){index in
                                Text(self.conditions[index]).tag(index)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        Text("Select the condition that best fits your item")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(Color.gray)
                    }
                    field(title: "Category", placeholderText: "Select the category of the item", bindingValue: $category, validationBinding: $categoryValid,completionHandler: {self.validateField(field: Field.category)})
                    field(title: "Daily Price", placeholderText: "Price per day", bindingValue: $dailyPrice, validationBinding: $dailyPriceValid,helperText: "Enter the price it would cost someone to borrow your item per day",keyboardType:.numberPad,currency: "£",completionHandler: {self.validateField(field: Field.dailyPrice)})
                    field(title: "Available Quantity", placeholderText: "Enter quantity", bindingValue: $quantity, validationBinding: $quantityValid,keyboardType: .numberPad){self.validateField(field: Field.availableQuantity)}
                    field(title: "Description", placeholderText: "Enter a description", bindingValue: $description, validationBinding: $descriptionValid, completionHandler: {self.validateField(field: Field.description)})
                    field(title:"Pick Up Location",placeholderText: "Enter pickup location",bindingValue: $pickUpLocation, validationBinding: $pickUpLocationValid,helperText: "Enter the location a customer should pick up the item from, read our safety guidlines here",completionHandler: {self.validateField(field: Field.pickUpLocation)})
                }
                Button(action:{self.submitChanges()}){Capsule().frame(width:150,height:50).foregroundColor(Color("Teal")).overlay(Text("Submit").font(.headline).fontWeight(.bold).foregroundColor(Color.white))}.padding()
                    .padding(.vertical)
                Spacer()
                    .frame(height:UIScreen.main.bounds.height*0.4)
            }
        }
        .padding()
        .onAppear{
            if(self.itemFunction == ItemFunction.edit && self.item != nil){
                self.title = self.item!.title
                self.category = self.item!.category
                self.setCondtionPicker(itemCondtion: self.item!.condition)
                self.dailyPrice = self.item!.dailyPrice.description
                self.description = self.item!.description
                self.quantity = self.item!.quantity.description
                self.pickUpLocation = self.item!.pickUpLocation
            }
        }
    }
    
    func setCondtionPicker(itemCondtion:String){
        self.conditionTag = self.conditions.firstIndex(of: itemCondtion) ?? 2
    }
    
    func field(title:String = "field",placeholderText:String = "Enter field",bindingValue:Binding<String>,validationBinding:Binding<(Bool,ErrorType?)?>,helperText:String?=nil,keyboardType:UIKeyboardType=UIKeyboardType.default,currency:String?=nil,completionHandler:@escaping ()->Void) -> some View{
        
        
        
        return
            VStack(alignment:.leading){
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .font(.subheadline)
                if(currency != nil){
                    HStack{
                        Text(currency!)
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                        TextField(placeholderText, text: bindingValue,onCommit: {
                            completionHandler()
                            print(title)
                            
                        })
                            .font(.subheadline)
                        //.keyboardType(keyboardType)
                    }
                }
                else{
                    TextField(placeholderText, text: bindingValue,onCommit: {
                        completionHandler()
                        print(title)
                    })
                        .font(.subheadline)
                    //.keyboardType(keyboardType)
                }
                
                Rectangle()
                    .frame(height:0.5)
                if (helperText != nil){
                    Text(helperText!)
                        .foregroundColor(Color.gray)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .fixedSize(horizontal: false, vertical: true)
                }
                if (validationBinding.wrappedValue != nil && validationBinding.wrappedValue!.1 != nil){
                    Text(self.returnErrorMessage(error: validationBinding.wrappedValue!.1!) ?? "")
                        .foregroundColor(Color.red)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .fixedSize(horizontal: false, vertical: true)
                }
        }
    }
    
    func validateField(field:Field){
        switch(field){
        case Field.title:
            if(self.title.isEmpty){
                self.titleValid = (false,ErrorType.emptyField)
            }
            else{
                self.titleValid = (true,nil)
            }
        case Field.condition:
            self.conditionsValid = (true,nil)
        case Field.category:
            if(self.category.isEmpty){
                self.categoryValid = (false,ErrorType.emptyField)
            }
            else{
                self.categoryValid = (true,nil)
            }
        case Field.dailyPrice:
            let dailyPrice = Double(self.dailyPrice)
            if(self.dailyPrice.isEmpty){
                self.dailyPriceValid = (false,ErrorType.emptyField)
            }
            else if (dailyPrice == nil || (dailyPrice != nil && dailyPrice! <= 0)){
                self.dailyPriceValid = (false,ErrorType.invalidInputRequiresPositiveNumbers)
            }
            else{
                self.dailyPriceValid = (true,nil)
            }
        case Field.availableQuantity:
            let quantity = Int(self.quantity)
            if(self.quantity.isEmpty){
                self.quantityValid = (false,ErrorType.emptyField)
            }
            else if (quantity == nil || (quantity != nil && quantity! <= 0)){
                self.quantityValid = (false,ErrorType.invalidInputRequiresPositiveIntegers)
            }
                
            else{
                self.quantityValid = (true,nil)
            }
        case Field.pickUpLocation:
            if(self.pickUpLocation.isEmpty){
                self.pickUpLocationValid = (false,ErrorType.emptyField)
            }
            else{
                self.pickUpLocationValid = (true,nil)
            }
            
        case Field.description:
            if(self.description.isEmpty){
                self.descriptionValid = (false,ErrorType.emptyField)
            }
            else{
                self.descriptionValid = (true,nil)
            }
        default:
            print("no validation required")
        }
    }
    
    func validateList(list:[Field]){
        for field in list{
            self.validateField(field: field)
        }
    }
    
    func allFieldsValid() -> Bool{
        return
            (self.titleValid != nil && self.titleValid!.0
                && self.conditionsValid != nil && self.conditionsValid!.0
                && self.categoryValid != nil && self.categoryValid!.0
                && self.dailyPriceValid != nil && self.dailyPriceValid!.0
                && self.quantityValid != nil && self.quantityValid!.0
                && self.pickUpLocationValid != nil && self.pickUpLocationValid!.0
                && self.descriptionValid != nil && self.descriptionValid!.0)
        
    }
    
    func submitChanges(){
        self.validateList(list: [Field.title,Field.condition,Field.category,Field.dailyPrice,Field.pickUpLocation,Field.availableQuantity,Field.description])
        
        if(self.allFieldsValid()){
            if(itemFunction == ItemFunction.edit && self.item != nil){
                
                let updatedItem = Item(itemID: self.item!.itemID, sellerID: self.item!.sellerID, title: self.title, category: self.category, condition: self.conditions[self.conditionTag], dailyPrice: Double(self.dailyPrice) ?? 0, description: self.description, quantity: Int(self.quantity) ?? 0, pickUpLocation: self.pickUpLocation)
                
                Session.shared.updateItem(updatedItem: updatedItem) { (err) in
                    if let err = err{
                        self.alertIsShown = true
                        print(err)
                    }
                    else{
                        self.dismissModal()
                    }
                }
            }
            else if(itemFunction == ItemFunction.create){
                
                if let user = self.user{
                    let newItem = ItemSubmission(sellerID: user.userID, title: self.title, category: self.category, condition: self.conditions[self.conditionTag], dailyPrice: Double(self.dailyPrice) ?? 0, description: self.description, quantity: Int(self.quantity) ?? 0, pickUpLocation: self.pickUpLocation)
                    
                    Session.shared.addItem(itemSub: newItem,completionHandler: {(err) in
                        if let err = err{
                            print(err)
                            self.dismissModal()
                        }
                        else{
                            self.dismissModal()
                        }
                    })
                }
            }
            //ADD alert
        }
        else{
            print("Errror")
        }
    }
    
    /*
    func dismissModal(){
        self.modalIsVisible = false
        self.modalContent = AnyView(EmptyView())
    }
    */
    
    func returnErrorMessage(error:ErrorType)->String?{
        if(error == ErrorType.emptyField){
            return "This field cannot be left empty"
        }
        else if(error == ErrorType.invalidInputRequiresPositiveNumbers){
            return "Invalid input, please enter numbers above 0 only"
        }
        else if(error == ErrorType.invalidInputRequiresPositiveIntegers){
            return "Invalid input, please enter whole numbers above 0 only"
        }
        else{
            return nil
        }
    }
    
    enum Field{
        case title
        case condition
        case category
        case dailyPrice
        case availableQuantity
        case description
        case pickUpLocation
    }
    
    enum ErrorType{
        case emptyField
        case invalidInputRequiresPositiveNumbers
        case invalidInputRequiresPositiveIntegers
    }
    
    enum ItemFunction{
        case edit
        case create
    }
    
}

struct ResultDetail_Previews: PreviewProvider {
    static var previews: some View {
        //ResultDetail.EditItemModal(item: DummyData.items[0])
        ResultDetail(item: DummyData.items[1], isLocalUserItem: false)
    }
}
