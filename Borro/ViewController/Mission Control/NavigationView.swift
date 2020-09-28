//
//  NavigationView.swift
//  Borro
//
//  Created by Miles Broomfield on 29/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

class NavigationStack:ObservableObject{
    
    var baseView:NavigationItem
    
    @Published var viewStack:[NavigationItem] = []
    @Published var currentView:NavigationItem
    @Published var lastCommand:Int? = nil
    
    init(){
        self.baseView = NavigationItem(view: AnyView(EmptyView()))
        self.currentView = self.baseView
    }
    
    func setBaseView(view:NavigationItem){
        self.baseView = view
        self.currentView = self.baseView
    }
    
    func unwind(){
        if viewStack.count != 0{
            let last = viewStack.count - 1
            currentView = viewStack[last]
            viewStack.remove(at: last)
            self.lastCommand = -1
        }
    }
    
    func advance(destination:NavigationItem){
        viewStack.append(currentView)
        currentView = destination
        self.lastCommand = 1
    }
    
    func home(){
        currentView = baseView
        viewStack.removeAll()
        self.lastCommand = nil
    }
    
}

struct NavigationItem:View{
    
    var view:AnyView

    var body: some View{
        GeometryReader{ geometry in
            ZStack{
                Color.white
                    .frame(width:geometry.size.width,height:geometry.size.height)
                view
            }
        }
    }
}

struct NavigationHost:View{
    
    @ObservedObject var navigation:NavigationStack
    @State var testOffset:CGFloat = UIScreen.main.bounds.width
    @State var advanceOffset:CGFloat = UIScreen.main.bounds.width
    @State var unwindOffset:CGFloat = 0
    
    var body: some View{
        GeometryReader{ geometry in
            ZStack{
                if(self.navigation.viewStack.count > 0){
                    self.navigation.viewStack[self.navigation.viewStack.count-1]
                    self.navigation.currentView
                }
                else{
                    self.navigation.currentView
                }
            }
        }
    }
    
}

struct HomeView:View{
    
    let text:String
    let navigation = NavigationStack()
    
    var body: some View{
        NavigationHost(navigation: navigation)
            .onAppear{
                self.navigation.setBaseView(view: NavigationItem(view: AnyView(view())))
            }
    }
    
    func view() -> some View{
        return
            Text(text)
                .background(Color.blue)
                .onTapGesture {
                    self.navigation.advance(destination: NavigationItem(view: AnyView(Second(navigation: self.navigation))))
                }
    }
}

struct Second:View{
    
    @ObservedObject var navigation:NavigationStack
    
    var body: some View{
        Text("Click to go to third")
            .background(Color.blue)
            .onTapGesture {
                self.navigation.advance(destination: NavigationItem(view: AnyView(Third(navigation: self.navigation))))
            }
    }
}

struct Third:View{
    
    @ObservedObject var navigation:NavigationStack
    
    var body: some View{
        Text("Click to return home")
            .background(Color.yellow)
            .onTapGesture {
                self.navigation.home()
            }
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView(text: "Tap to move to next view")
        }
    }
}
