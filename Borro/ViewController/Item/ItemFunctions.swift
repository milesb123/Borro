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
    @State var addedCategories:[String] = []
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
                Button(action:{self.dismissModal()}){Image(systemName:"xmark.circle.fill").resizable().frame(width:30,height:30).foregroundColor(Color("Teal"))}
            }
            ScrollView{
                VStack(alignment: .leading,spacing:20){
                    //Helper Text
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
                    //Title
                    field(title: "Title", placeholderText: "Enter the title of the item", bindingValue: $title, validationBinding: $titleValid,completionHandler: {self.validateField(field: FieldType.title)})
                    
                    //Image Section
                    Group{
                        Text("Images")
                            .font(.headline)
                            .fontWeight(.bold)
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                if(self.uploadImages.isEmpty){
                                    if(itemFunction == ItemFunction.edit){
                                        if(self.item != nil && !self.item!.images.isEmpty){
                                            ForEach((HelperFunctions.identifiableList(array:self.downloadedMedia)), id: \.self.1){img in
                                                
                                                ZStack{
                                                    VStack{
                                                        img.0
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
                                                                    if let uiimage = (img.0).imageLoader.downloadedImage{
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
                                        ForEach((HelperFunctions.identifiableList(array: [])), id: \.self.1){img in
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
                    
                    //Condition Picker
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
                    
                    categorySection()
                    
                    //Simple Fields
                    Group{
                        field(title: "Daily Price", placeholderText: "Price per day", bindingValue: $dailyPrice, validationBinding: $dailyPriceValid,helperText: "Enter the price it would cost someone to borrow your item per day",keyboardType:.numberPad,currency: "£",completionHandler: {self.validateField(field: FieldType.dailyPrice)})
                        field(title: "Available Quantity", placeholderText: "Enter quantity", bindingValue: $quantity, validationBinding: $quantityValid,keyboardType: .numberPad){self.validateField(field: FieldType.availableQuantity)}
                        field(title: "Description", placeholderText: "Enter a description", bindingValue: $description, validationBinding: $descriptionValid, completionHandler: {self.validateField(field: FieldType.description)})
                        field(title:"Pick Up Location",placeholderText: "Enter pickup location",bindingValue: $pickUpLocation, validationBinding: $pickUpLocationValid,helperText: "Enter the location a customer should pick up the item from, read our safety guidlines here",completionHandler: {self.validateField(field: FieldType.pickUpLocation)})
                    }
                }
                //Submit Button
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
                self.category = ""
                self.addedCategories = self.item!.categories
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
    
    func categorySection() -> some View{
        return
        VStack(alignment:.leading){
            Text("Category")
                .font(.headline)
                .fontWeight(.bold)
                .font(.subheadline)
            DropdownMenuTypable(textField: $category, onAdd: self.addCategorytoList)
                .animation(.easeInOut)
                //Adds error message
            if (self.categoryValid != nil && self.categoryValid!.1 != nil && !self.categoryValid!.0){
                Text(self.returnErrorMessage(error: self.categoryValid!.1!) ?? "")
                    .foregroundColor(Color.red)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .fixedSize(horizontal: false, vertical: true)
            }
            else if (self.categoryValid != nil && self.categoryValid!.1 != nil && self.categoryValid!.0){
                Text(self.returnErrorMessage(error: self.categoryValid!.1!) ?? "")
                    .foregroundColor(Color.yellow)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Text("Add up to 5 keywords or categories, categories from the list are more popular however you can add your own too")
                .foregroundColor(Color.gray)
                .font(.subheadline)
                .fontWeight(.light)
                .fixedSize(horizontal: false, vertical: true)
            ScrollView(.horizontal){
                HStack{
                    ForEach((HelperFunctions.identifiableList(array: addedCategories)),id: \.1){category in
                        HStack(spacing:10){
                            Text("\(category.0) ")
                                .foregroundColor(Color.white)
                                .font(.caption)
                                .fontWeight(.light)
                            Button(action:{
                                self.deleteCategory(category: category.0)
                            }){
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width:8,height:8)
                                .foregroundColor(Color.white)
                            }
                        }
                        .padding(8)
                        .background(Color("Teal"))
                    }
                }
            }
        }
    }
    
    //Returns a field view
    
    func field(title:String = "field",placeholderText:String = "Enter field",bindingValue:Binding<String>,validationBinding:Binding<(Bool,ErrorType?)?>,helperText:String?=nil,keyboardType:UIKeyboardType=UIKeyboardType.default,currency:String?=nil,completionHandler:@escaping ()->Void) -> some View{
        return
            VStack(alignment:.leading){
                //Title
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .font(.subheadline)
                
                //Adds currency label
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
                    .frame(height:1)
                
                //Adds error message
                if (validationBinding.wrappedValue != nil && validationBinding.wrappedValue!.1 != nil){
                    Text(self.returnErrorMessage(error: validationBinding.wrappedValue!.1!) ?? "")
                        .foregroundColor(Color.red)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .fixedSize(horizontal: false, vertical: true)
                }
                //Adds helper text
                if (helperText != nil){
                    Text(helperText!)
                        .foregroundColor(Color.gray)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .fixedSize(horizontal: false, vertical: true)
                }
        }
    }
    
    //Categories
    
    func addCategorytoList() -> Void{
        if(!self.category.isEmpty){
            if(self.addedCategories.contains(self.category)){
                self.categoryValid = (true,ErrorType.categoryAlreadyExists)
            }
            else{
                if(self.addedCategories.count<5){
                    self.addedCategories.append(self.category)
                }
                self.validateField(field: .category)
            }
            self.category = ""
        }
    }
    
    func deleteCategory(category:String){
        if let categoryIndex = self.addedCategories.firstIndex(where: {$0 == category}){
            self.addedCategories.remove(at: categoryIndex)
        }
    }
    
    //Images
    
    func addImageTapped(){
        self.pickerIsPresented = true
    }
    
    //Removes an image from the new list of images to be uploaded
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
    
    //To be called when the picker finishes picking an image
    func finishedPickingImage(){
        
        //REFACTOR so that it only adds new images
        
        //Add uploaded image tp upload list
        
        if let img = self.chosenImage{
            self.uploadImages.append(img)
        }
        
        //Dismiss Picker
        
        self.pickerIsPresented = false
        
    }
    
    //Returns a list of ui images for display within the view from the relevant list types
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
    
    //Loads images from a given item
    func loadImages(item:Item){
        
        for img in item.images{
            self.downloadedMedia.append(StorageImage(fullPath:img,height:100,contentMode:.fit))
        }
        
    }
    
    //Sets the condition field based on a given condition from the list of conditions
    func setCondtionPicker(itemCondtion:String){
        self.conditionTag = self.conditions.firstIndex(of: itemCondtion) ?? 2
    }
    
    
    //Validation
    
    //Validates a given field based on the given typpe
    func validateField(field:FieldType){
        switch(field){
        case FieldType.title:
            if(self.title.isEmpty){
                self.titleValid = (false,ErrorType.emptyField)
            }
            else{
                self.titleValid = (true,nil)
            }
        case FieldType.condition:
            self.conditionsValid = (true,nil)
        case FieldType.category:
            //ORDER OF EXECUTION MATTERS
            //Categories can't be empty
            //You cannot add a category that has already been selected
            //You cannot exceed more than 5 categories
            if(self.addedCategories.isEmpty){
                self.categoryValid = (false,ErrorType.emptyField)
            }
            else if(self.addedCategories.count == 5){
                self.categoryValid = (true,ErrorType.tooManyCategoriesSelected)
            }
            else if(self.addedCategories.count > 5){
                self.categoryValid = (false,ErrorType.tooManyCategoriesSelected)
            }
            else{
                self.categoryValid = (true,nil)
            }
        case FieldType.dailyPrice:
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
        case FieldType.availableQuantity:
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
        case FieldType.pickUpLocation:
            if(self.pickUpLocation.isEmpty){
                self.pickUpLocationValid = (false,ErrorType.emptyField)
            }
            else{
                self.pickUpLocationValid = (true,nil)
            }
            
        case FieldType.description:
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
    
    //validates a list of fields from a given array of field types
    func validateList(list:[FieldType]){
        for field in list{
            self.validateField(field: field)
        }
    }
    
    //Returns true if all fields are valid
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
    
    //Submits changes from the input form
    func submitChanges(){
        
        //Validates all fields within the list
        self.validateList(list: [FieldType.title,FieldType.condition,FieldType.category,FieldType.dailyPrice,FieldType.pickUpLocation,FieldType.availableQuantity,FieldType.description])
        
        if(self.allFieldsValid()){
            //Fields are valid
            if(itemFunction == ItemFunction.edit && self.item != nil){
                //This modal edits items
                
                let updatedItem = Item(itemID: self.item!.itemID, sellerID: self.item!.sellerID, title: self.title, categories: self.addedCategories, condition: self.conditions[self.conditionTag], dailyPrice: Double(self.dailyPrice) ?? 0, description: self.description, quantity: Int(self.quantity) ?? 0, pickUpLocation: self.pickUpLocation, images: [])
                
                //Updates item within Firebase
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
                //This modal creates items
                if let user = self.user{
                    let newItem = ItemSubmission(sellerID: user.userID, title: self.title, categories: self.addedCategories, condition: self.conditions[self.conditionTag], dailyPrice: Double(self.dailyPrice) ?? 0, description: self.description, quantity: Int(self.quantity) ?? 0, pickUpLocation: self.pickUpLocation)
                    
                    //Creates item within Firebase
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
        }
        else{
            //Some fields are not valid
            
            //Present alert
            print("Error: All fields are not valid")
        }
    }
    
    //Returns error messages from a given error type
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
        else if(error == ErrorType.categoryAlreadyExists){
            return "You have already selected this category"
        }
        else if(error == ErrorType.tooManyCategoriesSelected){
            return "You cannot exceed 5 categories"
        }
        else{
            return nil
        }
    }
    
    enum FieldType{
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
        case tooManyCategoriesSelected
        case categoryAlreadyExists
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
