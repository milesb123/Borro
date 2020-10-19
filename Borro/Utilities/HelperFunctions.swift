//
//  HelperFunctions.swift
//  Borro
//
//  Created by Miles Broomfield on 08/10/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import Foundation

struct HelperFunctions{
    
    //Returns an identifiable list from an array of a given type T for use within ForEach Loops or other dynamically generated views
    static func identifiableList<T>(array:[T]) -> [(T,UUID)]{
        
        var newList:[(T,UUID)] = []
        
        for e in array{
            newList.append((e,UUID()))
        }
        
        return newList
    }
    
    static func sortedCategoryList(categories:[String],search:String) -> [String]{
        
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

class BooleanPublisher{
    
    @Published var present:Bool = false
    
    
    func presentMenu(){
        self.present = true
    }
    
    func hideMenu(){
        self.present = false
    }
    
}
