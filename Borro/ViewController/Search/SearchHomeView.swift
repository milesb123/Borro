//
//  SearchHomeView.swift
//  Borro
//
//  Created by Miles Broomfield on 01/10/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct SearchHomeView:View{
    
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
