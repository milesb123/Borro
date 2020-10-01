//
//  SearchResults.swift
//  Borro
//
//  Created by Miles Broomfield on 07/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    
    @Binding var searchField:String
    @State var filters:[Filter] = []
    @State var results:[Item] = []
    
    var body: some View {
        //NavigationView{
            VStack(spacing:0){
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
                                                ResultDetail(item: result, isLocalUserItem: Session.shared.userServices.userIsLocal(userID: result.sellerID))
                                ){
                                    SearchResultView(searchResultView: self, item: result)
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
        Session.shared.itemServices.getAllItems { optionalItems,err in
            if let err = err{
                print(err)
            }
            if let rawItems = optionalItems{
                self.results = SearchFunctions.filterBySearch(search: Search(text: text, filters: filters), items: rawItems)
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
                    StorageImage(fullPath: item.images[0], cornerRadius: 0, height: UIScreen.main.bounds.height*0.25)
                }
                else{
                    Rectangle()
                        .foregroundColor(Color("lightGray"))
                        .frame(height:UIScreen.main.bounds.height*0.25)
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

struct SearchResultView:View{
    
    let searchResultView:SearchView
    
    let item:Item
    
    @State var distance:Float = 0
    
    var body: some View{
        VStack{
            VStack(spacing:10){
                if(!item.images.isEmpty){
                    StorageImage(fullPath: item.images[0], cornerRadius: 0, height: UIScreen.main.bounds.height*0.25)
                }
                else{
                    Rectangle()
                        .foregroundColor(Color("lightGray"))
                        .frame(height:UIScreen.main.bounds.height*0.25)
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
                                Image(systemName:"star.fill")
                                    .resizable()
                                    .foregroundColor(Color("Teal"))
                                    .frame(width:15,height:15)
                                Text("4.4 (500+ Reviews)")
                                .foregroundColor(Color("Teal"))
                                .font(.subheadline)
                                .fontWeight(.light)
                            }
                        }
                        HStack{
                            Image(systemName:"mappin.and.ellipse")
                                .resizable()
                                .foregroundColor(Color("Teal"))
                                .frame(width:15,height:15)
                            Text("\(distance.description) Km Away")
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
        .onAppear{
            Session.shared.distanceFromItem(itemID: self.item.itemID, distance: &self.distance)
        }
    }
    
}
