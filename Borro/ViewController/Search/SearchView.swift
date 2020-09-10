//
//  SearchResults.swift
//  Borro
//
//  Created by Miles Broomfield on 07/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchField:String = ""
    @State var filters:[Filter] = []
    @State var results:[Item] = []
    
    var body: some View {
        //NavigationView{
            VStack(spacing:0){
                VStack(spacing:10){
                    ZStack{
                    VStack{
                        Spacer()
                        Color.white.shadow(radius: 5)
                            .frame(height:1)
                        
                    }
                    VStack{
                        Spacer()
                            .frame(height:20)
                        HStack(spacing: 30){
                            Capsule()
                            .foregroundColor(Color("lightGray"))
                                .frame(height:40)
                                .overlay(HStack{
                                    TextField("I want to borrow a...", text: $searchField,
                                              onCommit:{self.didCommitSearch(text: self.searchField, filters: self.filters)})
                                        .foregroundColor(Color.black)
                                        .font(.subheadline)
                                    Image(systemName:"magnifyingglass")
                                        .resizable()
                                        .frame(width:20,height:20)
                                    }.foregroundColor(Color.black).padding())
                            Button(action:{}){
                                Image(systemName:"slider.horizontal.3")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color.black)
                                    .frame(width:30,height:30)
                            }
                        }
                        .padding()
                    }
                    .background(Color.white)
                    }
                    .frame(height:60)
                }
                VStack(spacing:0){
                    if(!self.results.isEmpty){
                        HStack{
                            VStack(alignment: .leading,spacing:5){
                                Text("Search Results For \"\(self.searchField)\"")
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color.black)
                                Text("\(results.count) Displayed")
                                    .font(.subheadline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color("Teal"))
                            }
                            Spacer()
                        }
                        .padding(.top,30)
                        .padding(.bottom)
                        ScrollView{
                            ForEach(results, id: \.itemID){result in
                                NavigationLink(destination:
                                    ResultDetail(item: result, isLocalUserItem: Session.shared.userIsLocal(userID: result.sellerID))
                                ){
                                    self.searchResultView(item: result)
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            Spacer()
                        }
                    }
                    else{
                        Spacer()
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
    }
    
    private func resultNumberText(count:Int) -> Text{
        
        var string = ""
        
        if(count == 1){
            string = "\(count.description) result displayed"
        }
        else{
            string = "\(count.description) results displayed"
        }
        
        return Text(string)
    }
    
    private func didCommitSearch(text:String="",filters:[Filter]=[]){
        Session.shared.getAllItems { (optionalItems) in
            if let rawItems = optionalItems{
                self.results = SearchFunctions.filterBySearch(search: Search(text: text, filters: filters), items: rawItems)
            }
            else{
                print("There was an error loading items")
            }
        }
    }
    
    private func searchResultView(item:Item) -> some View{
        
        var distanceKm:Float = 0
        Session.shared.distanceFromItem(itemID: item.itemID, distance: &distanceKm)
        return
        VStack{
            VStack(spacing:10){
                if(!item.images.isEmpty){
                StorageImage(fullPath:item.images[0], placeholder: Image(systemName: "rectangle.fill"), cornerRadius: 0, height: UIScreen.main.bounds.height*0.25)
                }
                else{
                    Rectangle()
                        .foregroundColor(Color("lightGray"))
                        .frame(height: UIScreen.main.bounds.height*0.25)
                }
                HStack{
                    VStack(alignment: .leading,spacing: 5){
                        Text(item.title)
                            .font(.headline)
                            .fontWeight(.bold)
                        HStack{
                            Text("From £\(String(format:"%.2f",item.dailyPrice)) Per Day | ")
                                .font(.subheadline)
                                .fontWeight(.light)
                            Group{
                                /*
                                Text("Rating: 4.4 (500+ Reviews)")
                                    .foregroundColor(Color("Teal"))
                                    .font(.subheadline)
                                    .fontWeight(.light)
                                */
                                Image(systemName:"star.fill")
                                    .resizable()
                                    .foregroundColor(Color("Teal"))
                                    .frame(width:15,height:15)
                                Text("4.4 (500+ Reviews)")
                                .foregroundColor(Color("Teal"))
                                .font(.subheadline)
                                .fontWeight(.light)
                                /*
                                Image(systemName:"star.fill")
                                    .resizable()
                                    .foregroundColor(Color("Teal"))
                                    .frame(width:15,height:15)
                                Image(systemName:"star.fill")
                                    .resizable()
                                    .foregroundColor(Color("Teal"))
                                    .frame(width:15,height:15)
                                Image(systemName:"star.fill")
                                    .resizable()
                                    .foregroundColor(Color("Teal"))
                                    .frame(width:15,height:15)
                                Image(systemName:"star.lefthalf.fill")
                                    .resizable()
                                    .foregroundColor(Color("Teal"))
                                    .frame(width:15,height:15)
                                 */
                            }
                        }
                        HStack{
                            Image(systemName:"mappin.and.ellipse")
                                .resizable()
                                .foregroundColor(Color("Teal"))
                                .frame(width:15,height:15)
                            Text("\(distanceKm.description) Km Away")
                                //.foregroundColor(Color("Gray"))
                                .font(.subheadline)
                                .fontWeight(.light)
                        }
                    }
                    .foregroundColor(Color.black)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
