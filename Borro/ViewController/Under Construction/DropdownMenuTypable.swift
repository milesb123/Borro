//
//  TestView.swift
//  Borro
//
//  Created by Miles Broomfield on 01/10/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct DropdownMenuTypable: View {
    
    @Binding var textField:String
    @State var expanded = false
    @State var listHeight:CGFloat = 1
    
    let onAdd:()->Void
    
    var body: some View {
        VStack(spacing:0){
            HStack(spacing:20){
                TextField("Enter Keywords or Categrories", text: $textField,onCommit:{self.collapse(bool: $expanded)})
                    .onTapGesture(perform: {
                        self.expand(bool: $expanded)
                    })
                    .font(.subheadline)
                Button(action:{self.toggle(bool: $expanded)}){
                    if(expanded){
                        Image(systemName: "arrowtriangle.up.fill")
                            .foregroundColor(Color("Teal"))
                            .onAppear{
                                self.listHeight = 150
                            }
                    }
                    else{
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(Color("Teal"))
                            .onAppear{
                                self.listHeight = 1
                            }
                    }
                }
                Button(action:{self.onAdd()}){
                    Rectangle()
                        .frame(width:40,height:20)
                        .foregroundColor(Color("Teal"))
                        .overlay(Text("Add").foregroundColor(Color.white).font(.caption).fontWeight(.bold))
                }
                
            }
            .padding(.bottom)
            categoryListView()
                .frame(height:self.listHeight)
        }
    }
    
    func categoryListView() -> some View{

        return
        ScrollView{
            VStack(alignment: .leading){
                ForEach((HelperFunctions.identifiableList(array: self.sortedCategoryList(categories: Categories.categories, search: self.textField))),id: \.1){ category in
                        Button(action:{self.textField = category.0;self.collapse(bool: $expanded)}){
                        Text("\(category.0)")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(Color.black)
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    }
                }
                HStack{
                    Spacer()
                }
            }
        }
        .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }
    
    func toggle(bool:Binding<Bool>){
        bool.wrappedValue.toggle()
    }
    
    func expand(bool:Binding<Bool>){
        bool.wrappedValue = true
    }
    
    func collapse(bool:Binding<Bool>){
        bool.wrappedValue = false
    }
    
    func sortedCategoryList(categories:[String],search:String) -> [String]{
        
        var sortedCategories:[String] = []
        
        //Check for contains
        
        for category in categories.sorted(){
            if(category.lowercased().contains(search.lowercased())){
                sortedCategories.append(category)
            }
        }
        
        //Return Array of String
        return !search.isEmpty ? (sortedCategories) : (categories)
        
    }
}
