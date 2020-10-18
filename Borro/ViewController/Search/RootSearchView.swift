//
//  RootSearchView.swift
//  Borro
//
//  Created by Miles Broomfield on 30/09/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct RootSearchView: View {
    
    @State private var searchSubmission:SearchSubmission?
    @State var searchField:String = ""
    @State var results:[Item]? = []
    @State var filters:Set<Filter> = []
    @State var filtersPresented:Bool = false
    
    @State var searchBarSpace:CGFloat = UIScreen.main.bounds.height*0.15
    
    var body: some View{
        GeometryReader{ geo in
            ZStack{
                VStack(spacing:0){
                    GeometryReader{ container in
                        VStack{
                            Spacer()
                                .frame(height:self.searchBarSpace)
                            if(self.searchField.isEmpty && self.filters.isEmpty){
                                SearchHomeView(searchField: $searchField, results: $results, filters: $filters, rootSearchView: self)
                                    .onAppear{
                                        self.searchBarSpace = UIScreen.main.bounds.height*0.15
                                        self.results = nil
                                        self.filters = []
                                    }
                            }
                            else{
                                SearchedView(searchField: $searchField, results: $results, filters: $filters)
                                    .onAppear{
                                        self.searchBarSpace = UIScreen.main.bounds.height*0.225
                                    }
                            }
                        }
                        .frame(height:container.size.height)
                    }
                }
                .frame(width:geo.size.width)
                .overlay(VStack{searchBar();Spacer()})
                
                if(self.filtersPresented){
                    FilterPicker(dismiss: self.dismissFilterPicker, filters: $filters)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    private func searchBar() -> some View{
        return
        VStack{
            Spacer()
            if(!self.searchField.isEmpty || !self.filters.isEmpty){
                Button(action:{self.searchField.removeAll();self.filters.removeAll()}){
                    HStack{
                        Image(systemName: "arrow.left")
                        Text("Home")
                            .font(.caption)
                            .fontWeight(.light)
                        Spacer()
                    }
                    .foregroundColor(Color("Teal"))
                }
            }
            HStack{
                TextField("Search Here", text: $searchField,onCommit: {
                    self.didCommitSearch(searchSubmission: SearchSubmission(text: self.searchField, filters: self.filters), completion: {})
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
            if(!self.searchField.isEmpty || !self.filters.isEmpty){
                HStack{
                    self.searchTrayButton(text: "Filters", action: {self.presentFilterPicker()})
                    self.searchTrayButton(text: "Sort By", action: {})
                }
            }
        }
        .padding()
        .background(Color.white.shadow(radius: 5))
        .frame(height:self.searchBarSpace)
    }
    
    private func searchTrayButton(text:String, action:@escaping()->Void) -> some View{
        return
            Button(action:{action()}){
                Rectangle()
                    .foregroundColor(Color("Teal"))
                    .frame(height:30)
                    .overlay(Text(text).font(.subheadline).fontWeight(.light).foregroundColor(Color.white))
            }
    }
    
    func didCommitSearch(searchSubmission:SearchSubmission, completion: @escaping ()->Void ) -> Void{
        
        //Replace with get Items by search
        
        Session.shared.itemServices.getAllItems { optionalItems,err in
            if let err = err{
                print(err)
            }
            if let rawItems = optionalItems{
                completion()
                self.results = SearchFunctions.filterItemsBySearch(search: Search(text: searchSubmission.text, filters: searchSubmission.filters), items: rawItems)
                self.filters = searchSubmission.filters

            }
        }
    }
    
    private func presentFilterPicker(){
        self.dismissPickers()
        self.filtersPresented = true
    }
    
    private func dismissFilterPicker() -> Void{
        //dismiss all
        self.didFinishReducingList()
        self.dismissPickers()

    }
    
    private func dismissPickers(){
        self.filtersPresented = false
        //Sort By
    }
    
    private func didFinishReducingList(){
        if let results = self.results{
            print(self.filters)
            print(self.results)
            self.didCommitSearch(searchSubmission: SearchSubmission(text: self.searchField, filters: self.filters), completion: {})
            print(self.results)
        }
    }
    
    struct SearchSubmission{
        
        let text:String
        let filters:Set<Filter>
        
    }
    
}

struct FilterPicker:View{
    
    let dismiss:() -> Void
    
    @Binding var filters:Set<Filter>
    
    @State var categoryText:String = ""
    @State var categoryPickerPresented:Bool = false
    @State var categoriesAdded:Set<String> = []
    
    var body: some View{
        ZStack{
            Rectangle()
                .foregroundColor(Color.white)
                .shadow(radius: 5)
            VStack(spacing:20){
                HStack{
                    Text("Filters")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action:{self.updateSearchFilters();self.dismiss()}){Image(systemName:"xmark.circle.fill").resizable().frame(width:30,height:30).foregroundColor(Color("Teal"))}
                }
                
                HStack{
                    Button(action:{self.clearAllFilters()}){
                        Text("Clear All")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .underline()
                            .foregroundColor(Color("Teal"))
                    }
                    Spacer()
                }
                
                ScrollView{
                    categorySection()
                }
                //.padding(.top)
                Spacer()
            }
            .padding()
        }
        .frame(width:UIScreen.main.bounds.width*0.9,height:UIScreen.main.bounds.height*0.6)
        .onAppear{
            //Set Filters
            self.setFiltersFromSearch()
        }
    }
    
    func categorySection() -> some View{
        return
        VStack(alignment: .leading,spacing:20){
            HStack{
                Text("Categories")
                    .fontWeight(.light)
                Spacer()
                Button(action:{self.categoryPickerPresented.toggle()}){
                    if(!categoryPickerPresented){
                    Image(systemName: "plus")
                    }
                    else{
                        Text("Done")
                            .font(.caption)
                            .fontWeight(.light)
                    }
                }
                .foregroundColor(Color.black)
            }
            if(categoryPickerPresented){
                DropdownMenuTypable(list: Categories.categories, textField: $categoryText, onAdd: onAddCategory)
            }
            ScrollView(.horizontal,showsIndicators:false){
                HStack{
                    ForEach((HelperFunctions.identifiableList(array: Array(categoriesAdded))),id: \.1){category in
                        HStack(spacing:10){
                            Text("\(category.0) ")
                                .foregroundColor(Color.white)
                                .font(.caption)
                                .fontWeight(.light)
                            Button(action:{
                                self.deleteCategory(category: category.0)
                            }){
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width:8,height:8)
                                .foregroundColor(Color.white)
                            }
                        }
                        .padding(8)
                        .background(Color("Teal"))
                    }
                }
            }
            HStack{
                Spacer()
            }
        }
    }
    
    func onAddCategory() -> Void{
        if(!self.categoriesAdded.contains(self.categoryText) && !self.categoryText.isEmpty){
            self.categoriesAdded.insert(self.categoryText)
        }
        self.categoryText = ""
    }
    
    func deleteCategory(category:String){
        if let categoryIndex = self.categoriesAdded.firstIndex(where: {$0 == category}){
            self.categoriesAdded.remove(at: categoryIndex)
        }
    }
    
    func setFiltersFromSearch(){
        //Add to if statement when new filters added
        for filter in self.filters{
            if let filter = filter as? CategoryFilter{
                self.categoriesAdded = filter.categories
            }
        }
    }
    
    func updateSearchFilters(){
        //Update for each filter
        self.filters = []
        if(!self.categoriesAdded.isEmpty){
            self.filters.update(with: CategoryFilter(categories: Array(self.categoriesAdded)))
        }
    }
    
    func clearAllFilters(){
        //Reset input variables
        
        //Category
        
        self.categoriesAdded = []
        self.categoryPickerPresented = false
        
        self.filters = []
        self.setFiltersFromSearch()
    }
}

struct RootSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RootSearchView()
    }
}
