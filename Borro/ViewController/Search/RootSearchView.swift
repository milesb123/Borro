//
//  RootSearchView.swift
//  Borro
//
//  Created by Miles Broomfield on 30/09/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct RootSearchView: View {
    
    @State var searchField:String = ""
    
    var body: some View{
        GeometryReader{ geo in
            VStack(spacing:0){
                //searchBar(geo: geo)
                GeometryReader{ container in
                    VStack{
                        Spacer()
                            .frame(height:geo.size.height*0.15)
                        if(self.searchField.isEmpty){
                            WelcomeSearchView()
                        }
                        else{
                            SearchView(searchField: $searchField)
                        }
                    }
                    .frame(height:container.size.height)
                }
            }
            .frame(width:geo.size.width)
            .overlay(VStack{searchBar(geo: geo);Spacer()})
        }
        //.edgesIgnoringSafeArea(.vertical)
    }
    
    private func searchBar(geo:GeometryProxy) -> some View{
        return
        VStack{
            Spacer()
                //.frame(height:20)
            HStack{
                TextField("Search Here", text: $searchField)
                    .font(.subheadline)
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width:20,height:20)
                    .foregroundColor(Color("Teal"))
            }
            Rectangle()
                .frame(height:1)
                .padding(.vertical,5)
        }
        .padding()
        .background(Color.white.shadow(radius: 5))
        .frame(height:geo.size.height*0.15)
    }
}

struct WelcomeSearchView:View{
    
    var body: some View {
        GeometryReader{ geo in
            ScrollView{
                VStack(spacing:0){
                    promotionHeader()
                    VStack{
                        HStack{
                            Text("Top Categories")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                            Spacer()
                        }
                        HStack{
                            categoryView()
                            categoryView()
                        }
                        HStack{
                            categoryView()
                            categoryView()
                        }
                    }
                    .padding()
                    .foregroundColor(Color("lightGray"))
                    Button(action:{}){
                        Text("See All Categories")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(Color("Teal"))
                    }
                    VStack{
                        HStack{
                            Text("We thought you'd be interested in...")
                                .font(.headline)
                                .fontWeight(.light)
                            Spacer()
                        }
                        resultPreview()
                    }
                    .padding()
                    Spacer()
                }
            }
        }
    }
    private func promotionHeader() -> some View{
        return
        Button(action:{}){
            Rectangle()
                .frame(height:180)
                .foregroundColor(Color("Teal"))
        }
    }
    
    private func categoryView() -> some View{
        return
        Button(action:{}){
            Rectangle()
                .frame(height:100)
        }
    }
    
    private func resultPreview() -> some View{
        return
        ScrollView(.horizontal, showsIndicators: false){
            Button(action:{}){
            Rectangle()
                .foregroundColor(Color("lightGray"))
                .frame(width:100,height:100)
            }
        }
    }
    
}

struct SearchResultsView:View{
    
    var body: some View{
        Text("")
    }
}

struct RootSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RootSearchView()
    }
}
