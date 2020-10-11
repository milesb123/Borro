//
//  SearchFunctions.swift
//  Borro
//
//  Created by Miles Broomfield on 19/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import Foundation

class SearchFunctions{
    
    static func filterItemsBySearch(search:Search,items:[Item]) -> [Item]{
        
        var returnedItems:[Item] = []
        
        //Relevance
        for item in items{
            if(item.title.lowercased().contains(search.text.lowercased())){
                returnedItems.append(item)
            }
        }
        
        //Filter
        for filter in search.filters{
            returnedItems = filter.applyFilterForItems(items: returnedItems)
        }
        
        return returnedItems
    }
    
    static func filterlistByKeyword(list:[String],keyword:String) -> [String]{
        
        var returnedList:[String] = []
        
        for element in list{
            if(element.lowercased().contains(keyword.lowercased())){
                returnedList.append(keyword)
            }
        }
        
        return returnedList
    }
    
}
