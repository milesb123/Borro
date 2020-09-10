//
//  MainSearch.swift
//  Borro
//
//  Created by Miles Broomfield on 07/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct MainSearch: View {
    
    @State var view = 0
    @State var searchField = ""
    @State var categoryField = ""
    
    var body: some View {
        VStack{
            if(view == 0){
                VStack{
                    HStack{
                        Text("Borro")
                        Spacer()
                    }
                    
                        Text("I want to borrow a ....")
                    HStack{
                        TextField("Some Text", text: self.$searchField)
                        Button(action:{self.search(keyword: self.searchField, category: self.categoryField)}){Text("Search")}
                    }
                    HStack{
                        Text("Category")
                        Text(categoryField.description)
                    }
                }
            }
            else if(view == 1){
                SearchView()
            }
        }
    }
    
    func search(keyword:String,category:String){
        self.view = 1
    }
}

struct MainSearch_Previews: PreviewProvider {
    static var previews: some View {
        MainSearch()
    }
}
