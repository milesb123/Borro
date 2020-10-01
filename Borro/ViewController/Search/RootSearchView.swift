//
//  RootSearchView.swift
//  Borro
//
//  Created by Miles Broomfield on 30/09/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct RootSearchView: View {
    
    @State var searchSubmission:SearchSubmission?
    @State var searchField:String = ""
    @State var results:[Item] = []
    
    @State var searchBarSpace:CGFloat = UIScreen.main.bounds.height*0.15
    
    var body: some View{
        GeometryReader{ geo in
            VStack(spacing:0){
                GeometryReader{ container in
                    VStack{
                        Spacer()
                            .frame(height:self.searchBarSpace)
                        if(self.searchField.isEmpty){
                            SearchHomeView()
                                .onAppear{
                                    self.searchBarSpace = UIScreen.main.bounds.height*0.15
                                }
                        }
                        else{
                            SearchedView(searchField: $searchField, results: $results)
                                .onAppear{
                                    self.searchBarSpace = UIScreen.main.bounds.height*0.2
                                }
                        }
                    }
                    .frame(height:container.size.height)
                }
            }
            .frame(width:geo.size.width)
            .overlay(VStack{searchBar();Spacer()})
            
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    private func searchBar() -> some View{
        return
        VStack{
            Spacer()
                //.frame(height:20)
            HStack{
                TextField("Search Here", text: $searchField,onCommit: {
                        self.didCommit(searchSubmission: SearchSubmission(text: self.searchField, filters: []))
                })
                    .font(.subheadline)
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width:20,height:20)
                    .foregroundColor(Color("Teal"))
            }
            Rectangle()
                .frame(height:1)
                .padding(.vertical,5)
            HStack{
                if(!self.searchField.isEmpty){
                    self.searchTrayButton(text: "Filters", action: {})
                    self.searchTrayButton(text: "Sort By", action: {})
                }
            }
        }
        .padding()
        .background(Color.white.shadow(radius: 5))
        .frame(height:self.searchBarSpace)
    }
    
    func searchTrayButton(text:String, action:@escaping()->Void) -> some View{
        return
            Button(action:{action()}){
                Rectangle()
                    .foregroundColor(Color("Teal"))
                    .frame(height:30)
                    .overlay(Text(text).font(.subheadline).fontWeight(.light).foregroundColor(Color.white))
            }
    }
    
    func didCommit(searchSubmission:SearchSubmission){
        Session.shared.itemServices.getAllItems { optionalItems,err in
            if let err = err{
                print(err)
            }
            if let rawItems = optionalItems{
                self.results = SearchFunctions.filterBySearch(search: Search(text: searchSubmission.text, filters: searchSubmission.filters), items: rawItems)
            }
        }
    }
    
    struct SearchSubmission{
        
        let text:String
        let filters:[Filter]
        
    }
    
}

struct RootSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RootSearchView()
    }
}
