//
//  ItemFunctions.swift
//  Borro
//
//  Created by Miles Broomfield on 20/09/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct ItemFunctions: View {
    
    @EnvironmentObject var viewRouter:ViewRouter
    
    @State var pickerIsPresented:Bool = false
    
    let itemFunction:ItemFunction
    
    let dismissModal:()->Void
    
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
    
    @State var downloadedMedia:[StorageImage] = []
    @State var uploadImages:[UIImage] = []
    @State var chosenImage:UIImage?
    
    
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
                            .fixedSize(horizontal:false,vertical:true)
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
                                if(self.uploadImages.isEmpty){
                                    if(itemFunction == ItemFunction.edit){
                                        if(self.item != nil && !self.item!.images.isEmpty){
                                            ForEach((self.identifiableList(array:self.downloadedMedia)), id: \.self.1){img in
                                                
                                                ZStack{
                                                    VStack{
                                                        img.0 as! StorageImage
                                                        Spacer()
                                                    }
                                                    VStack{
                                                        Spacer()
                                                        HStack{
                                                            Rectangle()
                                                                .foregroundColor(Color.red)
                                                                .frame(height:15)
                                                                .overlay(Text("Delete Image").foregroundColor(Color.white).font(.system(size: 10)).fontWeight(.light))
                                                                .onTapGesture{
                                                                    if let uiimage = (img.0 as! StorageImage).imageLoader.downloadedImage{
                                                                        self.deleteImage(img: (uiimage))
                                                                    }
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                                .frame(width:100,height:100)
                                            }
                                        }
                                        else{
                                            Rectangle()
                                                .foregroundColor(Color("lightGray"))
                                                .frame(width:100,height:100)
                                        }
                                    }
                                }
                                else{
                                    if(self.item != nil){
                                        ForEach((self.identifiableList(array: [])), id: \.self.1){img in
                                            ZStack{
                                                VStack{
                                                    Image(uiImage: img.0 as! UIImage)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width:100)
                                                    Spacer()
                                                }
                                                VStack{
                                                    Spacer()
                                                    HStack{
                                                        Rectangle()
                                                            .foregroundColor(Color.red)
                                                            .frame(height:15)
                                                            .overlay(Text("Delete Image").foregroundColor(Color.white).font(.system(size: 10)).fontWeight(.light))
                                                            .onTapGesture{
                                                                self.deleteImage(img: img.0 as! UIImage)
                                                            }
                                                    }
                                                }
                                            }
                                            .frame(width:100,height:100)
                                        }
                                    }
                                }
                                Button(action:{self.addImageTapped()}){
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
                self.loadImages(item: self.item!)
            }
        }
        .sheet(isPresented: $pickerIsPresented, content: {
            ImagePicker(image: $chosenImage, onFinishedPicking: self.finishedPickingImage)
        })
    }
    
    func addImageTapped(){
        self.pickerIsPresented = true
    }
    
    func deleteImage(img:UIImage){
        
        if let index = self.downloadedMedia.firstIndex(where:{ $0.imageLoader.downloadedImage == img}){
            self.downloadedMedia.remove(at: index)
            return
        }
        
        if let index = self.uploadImages.firstIndex(where:{ $0 == img}){
            self.uploadImages.remove(at: index)
            return
        }
        
    }
    
    func finishedPickingImage(){
        
        //REFACTOR so that it only adds new images
        
        //Add uploaded image tp upload list
        
        if let img = self.chosenImage{
            self.uploadImages.append(img)
        }
        
        //Dismiss Picker
        
        self.pickerIsPresented = false
        
    }
    
    func displayUIImages() -> [UIImage]{
        var images:[UIImage] = []
        
        for img in self.downloadedMedia{
            if let uiimg = img.imageLoader.downloadedImage{
                images.append(uiimg)
            }
        }
        
        for img in self.uploadImages{
            images.append(img)
        }
        
        return images
    }
    
    func loadImages(item:Item){
        
        for img in item.images{
            self.downloadedMedia.append(StorageImage(fullPath:img,height:100,contentMode:.fit))
        }
        
    }
    
    func identifiableList(array:[Any]) -> [(Any,UUID)]{
        
        var newList:[(Any,UUID)] = []
        
        for e in array{
            newList.append((e,UUID()))
        }
        
        return newList
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
                        })
                            .font(.subheadline)
                        //.keyboardType(keyboardType)
                    }
                }
                else{
                    TextField(placeholderText, text: bindingValue,onCommit: {
                        completionHandler()
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
                
                let updatedItem = Item(itemID: self.item!.itemID, sellerID: self.item!.sellerID, title: self.title, category: self.category, condition: self.conditions[self.conditionTag], dailyPrice: Double(self.dailyPrice) ?? 0, description: self.description, quantity: Int(self.quantity) ?? 0, pickUpLocation: self.pickUpLocation, images: [])
                
                Session.shared.itemServices.updateItem(updatedItem: updatedItem) { (err) in
                    if let err = err{
                        self.viewRouter.presentAlert(alert: NativeAlert(alert: "Something Went Wrong", message: "Check your connection and try again", tip: nil, option1: ("Okay",nil), option2: nil))
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
                    
                    Session.shared.itemServices.addItem(itemSub: newItem,completionHandler: {(err) in
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

/*

struct ItemFunctions_Previews: PreviewProvider {
    static var previews: some View {
        ItemFunctions()
    }
}
*/
