//
//  LoginView.swift
//  Borro
//
//  Created by Miles Broomfield on 24/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State var alertIsShown:Bool = false
    @State var alert:Alert?
    
    @State var email:String = ""
    @State var password:String = ""
    @State var errorDisplayed:String?
    @State var disabled:Bool = false
    
    //Modal
    
    @State var modalIsDisplayed:Bool = false
    @State var modalContent:AnyView = AnyView(EmptyView())
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Rectangle()
                    .foregroundColor(Color("Teal"))
                    //.shadow(radius: 5)
                    .overlay(Text("Borro.").fontWeight(.bold).foregroundColor(Color.white)).font(.system(size: 50))
                    .frame(height: geometry.size.height*0.3)
                VStack{
                    if(self.errorDisplayed != nil){
                        Text("\(self.errorDisplayed!)")
                            .foregroundColor(Color.red)
                            .font(.subheadline)
                            .fontWeight(.thin)
                    }
                    Group{
                        self.inputField(placeholder: "Email", state: self.$email)
                        self.inputField(placeholder: "Password", state: self.$password)
                        
                    }
                    .padding(.bottom,40)
                    
                    Button(action:{self.loginButtonTapped()}){
                        Capsule()
                            .foregroundColor(Color("Teal"))
                            .shadow(radius: 5)
                            .frame(width:150,height:60)
                            .overlay(Text("Log In").font(.headline).fontWeight(.bold).foregroundColor(Color.white))
                    }
                    
                    VStack(spacing:15){
                        Button(action:{self.createAccountTapped()}){
                            Text("Create an Account")
                                .foregroundColor(Color.black)
                                .font(.subheadline)
                                .fontWeight(.thin)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Text("Forgot Password?")
                            .foregroundColor(Color.black)
                            .font(.subheadline)
                            .fontWeight(.thin)
                    }
                    .padding(.vertical)
                }
                .frame(width:geometry.size.width*0.8)
                .padding(.vertical,40)
                Spacer()
            }
            .disabled(self.disabled)
            .edgesIgnoringSafeArea(.top)
            .sheet(isPresented: self.$modalIsDisplayed, content: {self.modalContent})
            .alert(isPresented: self.$alertIsShown, content: {
                Alert(title: Text("Something Went Wrong"), message: Text("Check your connection or restart and try again"), dismissButton: .default(Text("Okay")))
            })
        }
    }
    
    
    func presentModal(content:AnyView){
        self.modalContent = content
        self.modalIsDisplayed = true
    }
    
    func createAccountTapped(){
        self.presentModal(content: AnyView(CreateProfileModal(alertShown: $alertIsShown, alert: $alert, modalContent: $modalContent, modalIsVisible: $modalIsDisplayed)))
    }
    
    func forgotPassword(){
        
    }
    
    func loginButtonTapped(){
        self.disabled = true
        Session.shared.signIn(email: self.email, password: self.password) { (error) in
            if let error = error{
                self.errorDisplayed = "Invalid email or password"
                self.disabled = false
            }
            else{
                self.disabled = false
            }
        }
    }
    
    func inputField(placeholder:String, state: Binding<String>) -> some View{
        return
        VStack{
            TextField(placeholder, text: state)
            Rectangle()
                .foregroundColor(Color.black)
                .frame(height: 1)
        }
    }
    
}


struct CreateProfileModal: View {
    
    @Binding var alertShown:Bool
    @Binding var alert:Alert?
    
    @Binding var modalContent:AnyView
    @Binding var modalIsVisible:Bool
    
    @State var fullName:String = ""
    @State var fullNameValidated:(Bool?,ErrorType?) = (nil,nil)
    
    @State var email:String = ""
    @State var emailValidated:(Bool?,ErrorType?) = (nil,nil)
    
    @State var password:String = ""
    @State var passwordValidated:(Bool?,ErrorType?) = (nil,nil)
    
    @State var mobile:String = ""
    @State var mobileValidated:(Bool?,ErrorType?) = (nil,nil)
    
    var body: some View {
        VStack(spacing:5){
            HStack{
                Text("Create Your Account")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                Spacer()
                Button(action:{self.dismissModal()}){Image(systemName:"xmark.circle.fill").resizable().frame(width:40,height:40).foregroundColor(Color("Teal"))}
            }
            ScrollView{
                VStack(alignment: .leading){
                    Group{
                    VStack(alignment: .leading,spacing: 10){
                        Text("1.Personal Information")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Fill out all the fields below and when your'e done tap the sign up button")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(Color.gray)
                    }
                    .padding(.bottom)
                    VStack(alignment: .leading,spacing:20){
                        field(fieldType: FieldType.fullName, fieldName: "Full Name", placeholderText: "Enter full name here", valueBinding: $fullName, validationBinding: $fullNameValidated) {
                            self.fullNameValidated =  self.validateName()
                            print("Called")
                        }
                        field(fieldType: FieldType.email, fieldName: "Email", placeholderText: "Enter email address here", valueBinding: $email, validationBinding: $emailValidated) {
                            self.emailValidated =  self.validateEmail()
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
                Button(action:{self.createUserTapped()}){Capsule()
                    .foregroundColor(Color("Teal"))
                    .frame(width:150,height:60)
                    .shadow(radius: 5)
                    .overlay(Text("Sign Up").font(.headline).fontWeight(.bold).foregroundColor(Color.white))}.padding(.vertical)
                
                Spacer()
                    .frame(height:200)
            }
        }
        .padding([.top,.horizontal],20)
    }
    
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
    
    func validateEmail() -> (Bool?,ErrorType?){
        //Validated if is correct email format and user is unique
        if(email.isEmpty){
            return (nil,nil)
        }
        else{
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            
            if(emailPred.evaluate(with: self.email)){
                //check for uniqueness
                Session.shared.userWithEmailExists(email: email.lowercased()) { (bool, err) in
                    if let _ = err{
                        self.emailValidated = (false,ErrorType.backendError)
                    }
                    if let bool = bool{
                        if (bool){
                            self.emailValidated = (!bool,ErrorType.associatedWithAccount)
                        }
                        else{
                            self.emailValidated = (!bool,nil)
                        }
                    }
                }
                return (nil,nil)
            }
            else{
                return (false,ErrorType.invalidInput)
            }
        }
    }
    
    func validatePassword() -> (Bool?,ErrorType?){
        //Validated if function returns true
        if(password.isEmpty){
            return (nil,nil)
        }
        else{
            return self.passwordIsStrong(password: password)
        }
    }
    
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
    
    func returnSubmissionEmail(email:String) -> String{
        return email.lowercased()
    }
    
    func createUserTapped(){
        
        if(validateName().0 == true && validateEmail().0 == true && validatePassword().0 == true && validateMobileNumber().0 == true){
            //All fields are validated
            Session.shared.createUser(newUser: NewUserSubmission(name: self.fullName, email: self.returnSubmissionEmail(email: self.email), password: self.password, mobile: self.returnSubmissionPhoneNumber(rawNumber: self.mobile))) { (err) in
                if let err = err{
                    print(err)
                    self.setAlert(alertBinding: self.$alert, title: "Sorry About This", message: "Something went wrong, check your connection or restart the app", buttonText: "Okay")
                    self.dismissModal()
                }
                else{
                    self.setAlert(alertBinding: self.$alert, title: "Success!", message: "Your account was created successfully")
                    self.dismissModal()
                }
            }
        }
        else{
            //Some or all fields need to be validated
            self.setAlert(alertBinding: self.$alert, title: "Check Fields", message: "Fill out all fields and ensure there are no errors")
        }
    }
    
    func setAlert(alertBinding:Binding<Alert?>,title:String = "Alert",message:String = "message",buttonText:String = "Okay"){
        alertBinding.wrappedValue = Alert(title: Text(title), message: Text(message), dismissButton: .default(Text(buttonText)))
        alertShown = true
    }
    
    func dismissModal(){
        self.modalIsVisible = false
        self.modalContent = AnyView(EmptyView())
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


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
