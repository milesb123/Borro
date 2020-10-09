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
}
