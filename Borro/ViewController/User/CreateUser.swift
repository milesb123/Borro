//
//  CreateProfile.swift
//  Borro
//
//  Created by Miles Broomfield on 20/09/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct CreateUser: View {
    
    //View Controller
    
    @EnvironmentObject var viewRouter:ViewRouter
    
    //Field Values and Validation States
    
    @State var fullName:String = ""
    @State var fullNameValidated:(Bool?,ErrorType?) = (nil,nil)
    
    @State var email:String = ""
    @State var emailValidated:(Bool?,ErrorType?) = (nil,nil)
    
    @State var password:String = ""
    @State var passwordValidated:(Bool?,ErrorType?) = (nil,nil)
    
    @State var mobile:String = ""
    @State var mobileValidated:(Bool?,ErrorType?) = (nil,nil)
    
    var body: some View{
        //Main Container
        VStack(spacing:5){
            //Title Bar
            HStack{
                Text("Create Your Account")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                Spacer()
                Button(action:{self.dismissModal()}){Image(systemName:"xmark.circle.fill").resizable().frame(width:30,height:30).foregroundColor(Color("Teal"))}
            }
            
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
                    Group{
                        //Sign Up Header
                        VStack(alignment: .leading,spacing: 10){
                            Text("Personal Information")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("Fill out all the fields below and when your'e done tap the sign up button")
                                .font(.subheadline)
                                .fontWeight(.light)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color.gray)
                        }
                        .padding(.bottom)
                        
                        //Field Stack
                        VStack(alignment: .leading,spacing:20){
                            field(fieldType: FieldType.fullName, fieldName: "Full Name", placeholderText: "Enter full name here", valueBinding: $fullName, validationBinding: $fullNameValidated) {
                                self.fullNameValidated =  self.validateName()
                            }
                            field(fieldType: FieldType.email, fieldName: "Email", placeholderText: "Enter email address here", valueBinding: $email, validationBinding: $emailValidated) {
                                self.validateEmail(completionHandler:{result in
                                    self.emailValidated = result
                                })
                            }
                            field(fieldType: FieldType.password, fieldName: "Password", placeholderText: "Enter password here", valueBinding: $password, validationBinding: $passwordValidated) {
                                self.passwordValidated = self.validatePassword()
                            }
                            field(fieldType: FieldType.mobile, fieldName: "Mobile Number", placeholderText: "Enter mobile number here", valueBinding: $mobile, validationBinding: $mobileValidated) {
                                self.mobileValidated = self.validateMobileNumber()
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .padding(.vertical)
                
                //Sign Up Button
                Button(action:{self.createUserTapped()}){Rectangle()
                    .foregroundColor(Color("Teal"))
                    .frame(height:50)
                    .overlay(Text("Sign Up").font(.headline).fontWeight(.bold).foregroundColor(Color.white))}.padding(.vertical)
                
                Spacer()
                    .frame(height:200)
            }
        }
        .padding([.top,.horizontal],20)

    }
    
    //Field View, field types are required and must be defined before creating new fields
    
    func field(fieldType:FieldType,fieldName:String = "Some Field",placeholderText:String = "Enter Field",valueBinding:Binding<String>,validationBinding:Binding<(Bool?,ErrorType?)>,completion:@escaping ()->Void) -> some View{
        return VStack(alignment: .leading){
            Text(fieldName)
                .font(.subheadline)
                .fontWeight(.bold)
            HStack{
                if(fieldType == FieldType.mobile){
                    Text("+44 ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(Color.gray)
                }
                TextField(fieldName, text: valueBinding, onCommit: completion)
                    .font(.subheadline)
                if(validationBinding.wrappedValue.0 == true){
                    VStack{
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(Color("Teal"))
                            .mask(Circle().foregroundColor(Color.white))
                        
                    }
                    .frame(width:20,height:20)
                }
            }
            Rectangle()
            .foregroundColor(Color.black)
                .frame(height:0.5)
            if(validationBinding.wrappedValue.0 == false){
                Text(self.returnErrorMessage(field: fieldType, errorType: validationBinding.wrappedValue.1))
                    .font(.system(size: 10))
                    .fontWeight(.light)
                    .foregroundColor(Color.red)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    //Validates Name
    
    func validateName() -> (Bool?,ErrorType?){
        //Valid if not empty
        if(fullName.isEmpty){
            return (nil,nil)
        }
        else{
            if(fullName.count <= 256){
                return (true,nil)
            }
            else{
                return (false,ErrorType.inputTooLong)
            }
        }
    }
    
    //Validates Email, requires completion handler for network request
    
    func validateEmail(completionHandler:@escaping((Bool?,ErrorType?))->Void){
        //Validated if is correct email format and user is unique
        if(email.isEmpty){
            completionHandler((nil,nil))
        }
        else{
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            
            if(emailPred.evaluate(with: self.email)){
                //check for uniqueness
                Session.shared.userServices.userWithEmailExists(email: email.lowercased()) { (bool, err) in
                    if let _ = err{
                        self.emailValidated = (false,ErrorType.backendError)
                        completionHandler((false,ErrorType.backendError))
                    }
                    if let bool = bool{
                        if (bool){
                            self.emailValidated = (!bool,ErrorType.associatedWithAccount)
                        }
                        else{
                            self.emailValidated = (!bool,nil)
                            completionHandler((!bool,nil))
                        }
                    }
                }
            }
            else{
               completionHandler((false,ErrorType.invalidInput))
            }
        }
    }
    
    //Validates Password
    
    func validatePassword() -> (Bool?,ErrorType?){
        //Validated if function returns true
        if(password.isEmpty){
            return (nil,nil)
        }
        else{
            return self.passwordIsStrong(password: password)
        }
    }
    
    //Password Helper Function
    
    func passwordIsStrong(password:String) -> (Bool?,ErrorType?){
        //Validated if string contains at least 6 characters and at least one capital letter
        let capitalRegEx  = ".*[A-Z]+.*"
        let capitalPred = NSPredicate(format:"SELF MATCHES %@", capitalRegEx)
        
        if(password.count>6 && capitalPred.evaluate(with: password)){
            return (true,nil)
        }
        else{
            return (false,ErrorType.invalidInput)
        }
    }
    
    //Validates mobile number
    
    func validateMobileNumber() -> (Bool?,ErrorType?){
        //Validated if it is an integer with length 10 or 11
        if(mobile.isEmpty){
            return (nil,nil)
        }
        else if(Int(mobile) != nil){
            if(mobile.count == 10 || mobile.count == 11){
               return (true,nil)
            }
            else{
                return (false,ErrorType.invalidInput)
            }
        }
        else{
            return (false,ErrorType.invalidInput)
        }
    }
    
    //returns a phone number string suitable for submission, should be called after validation
    
    func returnSubmissionPhoneNumber(rawNumber:String) -> String{
        
        var mobile = rawNumber
        
        if(mobile.count == 10){
            mobile = "+44"+mobile
            return mobile
        }
        else if(mobile.count == 11 && Array(mobile)[0] == "0"){
            var cleanedMobileString = ""
            
            var arrayMobile = Array(mobile)
            arrayMobile.remove(at: 0)
            cleanedMobileString+=String(arrayMobile)
            mobile = "+44"+cleanedMobileString
            return mobile
        }
        else{
            return "Error"
        }
    }
    
    //returns an email string suitable for submission, should be called after validation
    
    func returnSubmissionEmail(email:String) -> String{
        return email.lowercased()
    }
    
    func createUserTapped(){
        
        self.validateEmail { (result) in
            self.emailValidated = result
            self.fullNameValidated = validateName()
            self.passwordValidated = validatePassword()
            self.mobileValidated = validateMobileNumber()
            
            var alertTitle:String?
            var alertMessage:String?
            
            if(self.fullNameValidated.0 == true && self.emailValidated.0 == true && self.passwordValidated.0 == true && self.mobileValidated.0 == true){
                //All fields are validated
                Session.shared.userServices.createUser(newUser: NewUserSubmission(name: self.fullName, email: self.returnSubmissionEmail(email: self.email), password: self.password, mobile: self.returnSubmissionPhoneNumber(rawNumber: self.mobile))) { (err) in
                    if let err = err{
                        print(err)
                        alertTitle = "Sorry About This"
                        alertMessage = "Something went wrong, check your connection or restart the app"
                    }
                }
                self.dismissModal()
                if let message = alertMessage{
                    if let title = alertTitle{
                        self.setAlert(title: title, message: message,buttonText: "Okay")
                    }
                }
            }
            else{
                //Some or all fields need to be validated
                self.setAlert(title: "Check Fields", message: "Fill out all fields and ensure there are no errors")
            }
        }
    }
    
    func setAlert(title:String = "Alert",message:String = "message",buttonText:String = "Okay"){
        self.viewRouter.presentAlert(alert: NativeAlert(alert: title, message: message, tip: nil, warning: nil, option1: (buttonText,nil), option2: nil))
    }
    
    func dismissModal(){
        self.viewRouter.dismissModal()
    }
    
    enum FieldType:String{
        case fullName
        case email
        case password
        case mobile
    }
    
    enum ErrorType:String{
        case invalidInput
        case associatedWithAccount
        case inputTooLong
        case backendError
    }
    
    func returnErrorMessage(field:FieldType,errorType:ErrorType?) -> String{
        
        var message = ""
        
        switch(field){
            case FieldType.fullName:
                if(errorType == ErrorType.inputTooLong){
                    message = "You entered too many characters"
                }
            case FieldType.email:
                if(errorType == ErrorType.invalidInput){
                    message = "Invalid input, valid example: johnsmith@youremail.com"
                }
                else if(errorType ==  ErrorType.associatedWithAccount){
                    message = "An account for this email already exists, try a different email or change your password"
                }
                else if(errorType == ErrorType.backendError){
                    message = "Something went wrong"
                }
            case FieldType.password:
                if(errorType == ErrorType.invalidInput){
                    message = "Password too weak, must contain at least 6 characters and one capital letter"
                }
            case FieldType.mobile:
                if(errorType == ErrorType.invalidInput){
                    message = "Mobile number invalid, Note: Currently Borro only accepts U.K numbers"
                }
                else if(errorType == ErrorType.associatedWithAccount){
                    message = "An account for this number already exists, try a different number or change your password"
                }
            default:
            return "There was an error"
        }
        
        return message
    }
    
}

/*
struct CreateProfile_Previews: PreviewProvider {
    static var previews: some View {
    CreateProfile()
    }
}
*/
