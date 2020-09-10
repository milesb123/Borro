//
//  ContentView.swift
//  Borro
//
//  Created by Miles Broomfield on 07/08/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            
            MainSearch()
                .tabItem {
                    VStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                }
                .tag(0)
            Discover()
                .tabItem {
                    VStack {
                        Image(systemName: "globe")
                        Text("Discover")
                    }
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
