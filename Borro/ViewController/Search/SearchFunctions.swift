//
//  SearchFunctions.swift
//  Borro
//
//  Created by Miles Broomfield on 19/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import Foundation

class SearchFunctions{
    
    static func filterBySearch(search:Search,items:[Item]) -> [Item]{
        
        var returnedItems:[Item] = []
        
        for item in items{
            if(item.title.lowercased().contains(search.text.lowercased())){
                returnedItems.append(item)
            }
        }
        
        return returnedItems
    }
    
}
