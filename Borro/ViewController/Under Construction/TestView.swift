//
//  TestView.swift
//  Borro
//
//  Created by Miles Broomfield on 09/10/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct TestView: View {
    
    @State var height:CGFloat = 400
    
    var body: some View {
        VStack{
            Rectangle()
                .foregroundColor(.blue)
                .onTapGesture(perform: {
                    height += 50
                })
                .frame(height:height)
                .opacity(0.5)
            Rectangle()
                .foregroundColor(.red)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
