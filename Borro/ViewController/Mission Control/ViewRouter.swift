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
    
    @Published var alertShown = false
    @Published var alert:NativeAlert?
    
    @Published var popUpShown = false
    @Published var popUp = Text("")
    
    @Published var modalIsShown = false
    @Published var modalContent:AnyView?
    
    @Published var currentTab = 0
    
    var lastTab = 0

    func setNewTab(view:Int){
        self.lastTab = self.currentTab

        self.currentTab = view
    }
    
    func presentAlert(alert:NativeAlert){
        self.alert = alert
        self.alertShown = true
    }
    
    func presentModal(modalContent:AnyView){
        self.modalContent = modalContent
        self.modalIsShown = true
    }
    func dismissModal(){
        self.modalIsShown = false
    }
}
