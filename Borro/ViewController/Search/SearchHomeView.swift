//
//  SearchHomeView.swift
//  Borro
//
//  Created by Miles Broomfield on 01/10/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct SearchHomeView:View{
    
    @Binding var searchField:String
    @Binding var results:[Item]?
    @Binding var filters:Set<Filter>
    
    let rootSearchView:RootSearchView
    
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
                            categoryView(category: "Sporting Goods")
                            categoryView(category: "Apparel and Accessories")
                        }
                        HStack{
                            categoryView(category: "Electronics")
                            categoryView(category: "Health and Beauty")
                        }
                    }
                    .padding()

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
    
    private func categoryView(category:String) -> some View{
        return
            Button(action:{
                //Search items by category
                let filters:Set<Filter> = [CategoryFilter(categories: [category])]
                rootSearchView.didCommitSearch(searchSubmission: RootSearchView.SearchSubmission(text: self.searchField, filters: filters), completion: {})
            }){
            Rectangle()
                .frame(height:100)
                .overlay(Text(category).fontWeight(.light).foregroundColor(.black))
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
