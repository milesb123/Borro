//
//  ViewRouter.swift
//  Borro
//
//  Created by Miles Broomfield on 08/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import Foundation
import SwiftUI

class ViewRouter:ObservableObject{
    
    @Published var currentTab = 0
    
    var lastTab = 0

    func setNewTab(view:Int){
        self.lastTab = self.currentTab

        self.currentTab = view
    }
}
