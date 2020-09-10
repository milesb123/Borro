//
//  NavigationView.swift
//  Borro
//
//  Created by Miles Broomfield on 29/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

class NavigationStack:ObservableObject{
    
    let baseView:NavigationItem
    
    @Published var viewStack:[NavigationItem] = []
    @Published var currentView:NavigationItem
    
    init(baseView:NavigationItem){
        self.baseView = baseView
        self.currentView = baseView
    }
    
    func unwind(){
        if viewStack.count != 0{
            let last = viewStack.count - 1
            currentView = viewStack[last]
            viewStack.remove(at: last)
        }
    }
    
    func advance(destination:NavigationItem){
        viewStack.append(currentView)
        currentView = destination
    }
    
    func home(){
        currentView = baseView
        viewStack.removeAll()
    }
    
}

struct NavigationHost:View{
    
    let baseView:AnyView
    
    var body: some View{
        NavigationStage()
                .environmentObject(NavigationStack(baseView: NavigationItem(view: baseView)))
    }
    
    private struct NavigationStage: View {
        
        @EnvironmentObject var navigation:NavigationStack
        
        var body: some View {
            navigation.currentView
        }
        
    }
    
}

struct NavigationItem:View{
    
    var view:AnyView
    
    var body: some View{
        VStack{
            view
        }
    }
}

struct NavigationBackButton:View{
    
    @EnvironmentObject var navigation:NavigationStack
    
    var body: some View{
        Button(action:{self.navigation.unwind()}){
            Circle()
                .foregroundColor(Color("Teal"))
                .overlay(Image(systemName: "arrow.left.circle.fill").resizable().foregroundColor(Color.white))
                .frame(width:40,height:40)
                .shadow(radius: 5)
        }
    }
}

struct HomeView:View{
    
    let text:String
    @EnvironmentObject var navigation:NavigationStack
    
    var body: some View{
        Text(text)
            .background(Color.white)
            .onTapGesture {
                self.navigation.advance(destination: NavigationItem(view: AnyView(NextView())))
            }
    }
}

struct NextView:View{
    
    @EnvironmentObject var navigation:NavigationStack
    
    var body: some View{
        Text("Click to return")
            .background(Color.white)
            .onTapGesture {
                self.navigation.unwind()
            }
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            NavigationHost(baseView: AnyView(HomeView(text: "Home 1")))
        }
    }
}
