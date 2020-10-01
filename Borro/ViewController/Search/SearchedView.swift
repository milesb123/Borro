//
//  SearchResults.swift
//  Borro
//
//  Created by Miles Broomfield on 07/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct SearchedView: View {
    
    @Binding var searchField:String
    @Binding var results:[Item]
    
    var body: some View {
        VStack(spacing:0){
            VStack(spacing:0){
                if(!self.results.isEmpty){
                    HStack{
                        VStack(alignment: .leading,spacing:5){
                            Text("\(results.count) Displayed")
                                .font(.subheadline)
                                .fontWeight(.light)
                                .foregroundColor(Color("Teal"))
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                    ScrollView{
                        ForEach(results, id: \.itemID){result in
                            NavigationLink(destination:
                                ResultDetail(item: result, isLocalUserItem: Session.shared.userServices.userIsLocal(userID: result.sellerID))
                                        .navigationBarTitle(Text(result.title),displayMode:.inline)
                                        .navigationBarHidden(false)
                            ){
                                SearchResultRow(item: result)
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
        
}

struct SearchResultRow:View{
        
    let item:Item
    
    @State var distance:Float = 0
    
    var body: some View{
        VStack{
            VStack(spacing:10){
                if(false){
                    /*
                    StorageImage(fullPath: item.images[0], cornerRadius: 0, height: UIScreen.main.bounds.height*0.25)
                    */
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
                            Text("From £\(String(format:"%.2f",item.dailyPrice)) a Day")
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
