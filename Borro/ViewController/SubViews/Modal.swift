//
//  Modal.swift
//  Borro
//
//  Created by Miles Broomfield on 20/09/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct Modal: View {
    
    @EnvironmentObject var viewRouter:ViewRouter
    
    @State var modalOffset:CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        GeometryReader{ geometry in
            if(self.viewRouter.modalIsShown){
                ZStack{
                    VStack{
                        Rectangle()
                            .foregroundColor(Color.white)
                            //.cornerRadius(20)
                            .shadow(radius: 5)
                    }
                    self.viewRouter.modalContent ?? AnyView(Text("Empty Content"))
                }
                .padding()
            }
        }
        
    }
}

struct Modal_Previews: PreviewProvider {
    static var previews: some View {
        Modal().environmentObject(ViewRouter())
    }
}
