//
//  Session.swift
//  Borro
//
//  Created by Miles Broomfield on 13/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class Session{
    
    static let shared = Session()
    
    @Published var localUser:User?
    
    let userServices = UserServices()
    let itemServices = ItemServices()
    
    
    func uploadImage(path:String,data:Data,completionHandler:@escaping ((StorageMetadata?,Error?)->Void)){
        let storageRef = Storage.storage().reference()
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
                
        storageRef.child(path).putData(data, metadata: metadata) { (metadata, err) in
            completionHandler(metadata,err)
        }
    }
    
    
    //Dummy Methods
    
    //returns a user from a given ID DUMMYDATA
       
   func returnUser(UserID:String) -> User{
       
    var rUser:User = User(userID: "", fullName: "Unknown", email: "", mobile: "",image: "", sellerBio: "")
       
       for user in DummyData.users{
           if(UserID == user.userID){
               rUser = user
           }
       }
       
       return rUser
       
   }

    //returns number of quantity available if the item is in stock, if not it returns 0
    
    func itemInStock(itemID:String, stock: inout Int){
        var temp = 0
        
        for item in DummyData.items{
            if(itemID == item.itemID){
                temp = item.quantity
            }
        }
        
        stock = temp
        
    }
    
    //returns the distance from a pick up location in km for a given item
    
    func distanceFromItem(itemID:String, distance: inout Float){
        distance = 0.1
    }
    
}

struct NewUserSubmission{
    
    let name:String
    let email:String
    let password:String
    let mobile:String
    
}

class UserServices{
    
    let session:Session = Session.shared
    
    var users = Firestore.firestore().collection("users")
    
    //Takes a user submission and returns a dictionary uploadable to firebase
    func userToData(userSubmission:UserSubmission)->[String:Any]{
        
        var data = [usersFirebase.fullName.rawValue:userSubmission.fullName,usersFirebase.email.rawValue:userSubmission.email,usersFirebase.mobile.rawValue:userSubmission.mobile,usersFirebase.sellerBio.rawValue:userSubmission.sellerBio]
        
        if(!userSubmission.imageRef.isEmpty){
            data[usersFirebase.imageRef.rawValue] = userSubmission.imageRef
        }
        
        return data
        
    }
    
    //Takes a document and returns a user within the completion handler
    func documentToUser(document:DocumentSnapshot,completionHandler:@escaping(User?)->Void){
        if let data = document.data(){
                
            let user = User(userID: document.documentID, fullName: data[usersFirebase.fullName.rawValue] as! String, email: data[usersFirebase.email.rawValue] as! String, mobile: data[usersFirebase.mobile.rawValue] as! String, image: data[usersFirebase.imageRef.rawValue] as! String, sellerBio: data[usersFirebase.sellerBio.rawValue] as! String)
            
            completionHandler(user)
            
        }
        else{
                completionHandler(nil)
        }
    }
    
    //Signs user out
    func signOut(){
        do{
            try Auth.auth().signOut()
            Session.shared.localUser = nil
        }
        catch{
            print("Error Signing Out")
        }
            
        
    }
    
    //Takes login credentials, attempts to log user in and returns an error via completion if the user could not be logged in
    func signIn(email:String,password:String, completionHandler:@escaping (Error?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error{
                completionHandler(error)
            }
            if let result = result{
                self.getUserByAuthID(authID: result.user.uid) { (user, error) in
                    if let error = error{
                        completionHandler(error)
                    }
                    if let user = user{
                        self.session.localUser = user
                    }
                }
            }
        }
    }
    
    //Takes a newUserSubmission, attempts to create a new user, returns an erro via completion if the user could not be created
    func createUser(newUser:NewUserSubmission,completionHandler: @escaping(Error?) -> Void){
        Auth.auth().createUser(withEmail: newUser.email, password: newUser.password) { (result, error) in
            if let error = error{
                completionHandler(error)
            }
            if let result = result{
                let user = [usersFirebase.authID.rawValue:result.user.uid,usersFirebase.fullName.rawValue:newUser.name,usersFirebase.mobile.rawValue:newUser.mobile,usersFirebase.email.rawValue:newUser.email,usersFirebase.imageRef.rawValue:"",usersFirebase.sellerBio.rawValue:""]
                self.users.document().setData(user) { (error) in
                    if let error = error{
                        completionHandler(error)
                    }
                    else{
                        self.getUserByAuthID(authID: result.user.uid) { (user, err) in
                            if let err = err{
                                completionHandler(err)
                            }
                            else{
                                self.session.localUser = user
                            }
                        }
                    }
                }
            }
        }
    }
    
    //Takes an email, checks to see whether the email exists and returns a tuple of true if the email exists and an error if something went wrong
    func userWithEmailExists(email:String,completionHandler: @escaping(Bool?,Error?) -> Void){
        users.whereField(usersFirebase.email.rawValue, isEqualTo: email).getDocuments { (snapshot, err) in
            if let err = err{
                completionHandler(nil,err)
            }
            if let snapshot = snapshot{
                if(snapshot.documents.count >= 1){
                    completionHandler(true,nil)
                }
                else{
                    completionHandler(false,nil)
                }
            }
        }
    }
    
    //Resets the local user variable
    func reloadLocalUser(){}
    
    //Takes an authID, returns a user or an error if something went wrong via completion
    func getUserByAuthID(authID:String, completionHandler: @escaping (User?,Error?) -> Void){
        
        users.whereField(usersFirebase.authID.rawValue, isEqualTo: authID).getDocuments { (snapshot, error) in
            if let error = error{
                completionHandler(nil,error)
            }
            if let snapshot = snapshot{
                if (snapshot.documents.count != 1){
                    completionHandler(nil,FirebaseError.invalidNumberOfDocumentsReturned)
                }
                else{
                    let doc = snapshot.documents[0]
                    
                    self.documentToUser(document: doc, completionHandler: {(user) in
                        completionHandler(user,nil)
                    })
                    
                }
            }
        }
        
    }
    
    //Takes a userID, returns a user or an error if something went wrong via completion
    
    func getUserByDocumentID(userID:String, completionHandler: @escaping ((User?,Error?)) -> Void){
        
        users.document(userID).getDocument { (snapshot, err) in
            if err != nil{
                completionHandler((nil,err))
            }
            if let snapshot = snapshot{
                self.documentToUser(document: snapshot, completionHandler: {(user) in
                    completionHandler((user,nil))
                })
            }
        }
        
    }
    
    //Takes a userSubmission and attempts to update the current user's document, returns an error if something went wrong via completion
    func updateUser(userSub:UserSubmission, completionHandler: @escaping(Error?) -> Void){
        
        let updatedUser = self.userToData(userSubmission: userSub)
        
        users.document(userSub.userID).setData(updatedUser, merge: true){ (err) in
            completionHandler(err)
        }
        
    }
    
    //Returns true if the user in question is the local user
    func userIsLocal(userID:String) -> Bool{
    
        if let localUser = self.session.localUser{
            if(userID == localUser.userID){
                return true
            }
            else{
                return false
            }
        }
        else{
            return false
        }
    }
    
}

class ItemServices{
    
    let session:Session = Session.shared
    
    var items = Firestore.firestore().collection("items")
    
    //Takes an Item returns a dictionary uploadable to Firebase
    func itemToData(){}
    
    //Takes a document and returns an Item Via completion
    func documentToItem(querydocument:QueryDocumentSnapshot? = nil, documentSingle:DocumentSnapshot? = nil,completionHandler: @escaping (Item?)->Void ){
        //**MAKE ROBUST
        
        if(querydocument != nil){
            let document = querydocument!
            let data = document.data()
            
            completionHandler(dataToItem(data: data, docID: document.documentID))
            
        }
        else if(documentSingle != nil){
            let document = documentSingle!
            if let data = document.data(){
                
                completionHandler(dataToItem(data: data, docID: document.documentID))
            }
            else{
                completionHandler(nil)
            }
        }
        else{
            completionHandler(nil)
        }
        
    }
    
    //Takes a dictionary and returns an Item
    func dataToItem(data:[String:Any],docID:String)->Item{
        var imagePaths:[String] = []
        
        if let optionalImagePaths = data[itemsFirebase.images.rawValue] as! NSArray? as! [String]?{
            imagePaths = optionalImagePaths
        }

        
        let item  = Item(itemID: docID, sellerID: data[itemsFirebase.sellerID.rawValue] as! String, title: data[itemsFirebase.title.rawValue] as! String, category: data[itemsFirebase.category.rawValue] as! String, condition: data[itemsFirebase.condition.rawValue] as! String, dailyPrice: data[itemsFirebase.dailyPrice.rawValue] as! Double, description: data[itemsFirebase.description.rawValue] as! String, quantity: data[itemsFirebase.avQuantity.rawValue] as! Int, pickUpLocation: data[itemsFirebase.pickUpLocation.rawValue] as! String? ?? "", images: imagePaths)
        
        return item
        
    }
    
    //Returns a list of all items from Firebase Item collection via completion
    func getAllItems(completionHandler: @escaping ([Item]?,Error?)->Void){
        items.getDocuments { (snapshot, error) in
            if let error = error{
                completionHandler(nil,error)
            }
            if let snapshot = snapshot{
                let documents = snapshot.documents
                var items:[Item] = []
                for doc in documents{
                    self.documentToItem(querydocument: doc, completionHandler:{item in
                        if let safeItem = item{
                            items.append(safeItem)
                        }
                    })
                }
                completionHandler(items as [Item]?,nil)
            }
        }
    }
    
    //Takes a userID, and returns a list of items via completion
    func getItemsByUser(userID:String, completionHandler: @escaping ([Item]?,Error?) -> Void){
        items.whereField(itemsFirebase.sellerID.rawValue, isEqualTo: userID).getDocuments { (snapshot, error) in
            if let error = error{
                completionHandler(nil,error)
            }
            if let snapshot = snapshot{
                let documents = snapshot.documents
                var items:[Item] = []
                for doc in documents{
                    self.documentToItem(querydocument: doc, completionHandler:{item in
                        if let safeItem = item{
                            items.append(safeItem)
                        }
                    })
                }
                completionHandler(items as [Item]?,nil)
            }
        }
    }
    
    //Takes an itemID, returns a list of items or an error if something went wrong via completion
    func getItemByID(itemID:String,completionHandler: @escaping (Item?,Error?) -> Void){
        items.document(itemID).getDocument { (snapshot, err) in
            if let error = err{
                completionHandler(nil,error)
            }
            if let snapshot = snapshot{
                self.documentToItem(documentSingle:snapshot, completionHandler:{item in
                    completionHandler(item,nil)
                })
            }
        }
    }
    
    //Takes an itemSubmission, attempts to add the item to Firebase Item collection returns an error if something went wrong via completion
    func addItem(itemSub:ItemSubmission,completionHandler:@escaping (Error?)->Void){
        //format price into two decimal places
        
        let item = [itemsFirebase.sellerID.rawValue:itemSub.sellerID,
                    itemsFirebase.title.rawValue:itemSub.title,
                    itemsFirebase.category.rawValue:itemSub.category,
                    itemsFirebase.condition.rawValue:itemSub.condition,
                    itemsFirebase.description.rawValue:itemSub.description,
                    itemsFirebase.dailyPrice.rawValue:itemSub.dailyPrice,
                    itemsFirebase.maxQuantity.rawValue:itemSub.quantity,
                    itemsFirebase.avQuantity.rawValue:itemSub.quantity,
                    itemsFirebase.pickUpLocation.rawValue:itemSub.pickUpLocation
                    
            ] as [String : Any]
        
        items.addDocument(data: item) { (error) in
            completionHandler(error)
        }
    }
    
    //Takes an itemSubmission, attempts to delete the item to Firebase Item collection returns an error if something went wrong via completion
    func deleteItem(itemID:String, completionHandler: @escaping (Error?)->Void){
        items.document(itemID).delete { (err) in
            completionHandler(err)
        }
    }
    
    //Takes an itemSubmission, attempts to update the item to Firebase Item collection returns an error if something went wrong via completion
    func updateItem(updatedItem:Item,completionHandler: @escaping (Error?) -> Void){
        let item = [itemsFirebase.sellerID.rawValue:updatedItem.sellerID,
                    itemsFirebase.title.rawValue:updatedItem.title,
                    itemsFirebase.category.rawValue:updatedItem.category,
                    itemsFirebase.condition.rawValue:updatedItem.condition,
                    itemsFirebase.description.rawValue:updatedItem.description,
                    itemsFirebase.dailyPrice.rawValue:updatedItem.dailyPrice,
                    itemsFirebase.avQuantity.rawValue:updatedItem.quantity, itemsFirebase.maxQuantity.rawValue:updatedItem.quantity] as [String : Any]
        
        items.document(updatedItem.itemID).updateData(item) { (err) in
            completionHandler(err)
        }
        
    }
    
}
