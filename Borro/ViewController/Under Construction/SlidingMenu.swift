//
//  SlidingMenu.swift
//  Borro
//
//  Created by Miles Broomfield on 18/10/2020.
//  Copyright © 2020 Miles Broomfield. All rights reserved.
//

import SwiftUI

struct SlidingMenu: View {
    
    let publisher:BooleanPublisher
    
    @State var size: CGFloat = -UIScreen.main.bounds.width
    
    let presentedOffset = -UIScreen.main.bounds.width+200
    let hiddenOffset = -UIScreen.main.bounds.width
    let sufficientGesture:CGFloat = 100
    let view:AnyView
    
    //positive right
    //negative left
    
    var body: some View {
        VStack{
            view
        }
        .background(Color.white).shadow(radius: 5).offset(x:size)
        .gesture(DragGesture().onChanged({(value) in
            //moved right if menu is not already expanded
            if value.translation.width > 0 && !(self.size>=presentedOffset){
                self.size = value.translation.width
            }
            //moved left
            else if value.translation.width<0{
                self.size = hiddenOffset + value.translation.width
            }
        }).onEnded({ (value) in
            
            //moved right
            if value.translation.width > 0{
                //Sufficient gesture
                if value.translation.width > sufficientGesture{
                    //Can Present
                    self.size = presentedOffset
                }
                //Insufficient Gesture
                else{
                    //Remain in Position
                    self.size = hiddenOffset
                }
            }
            //moved left
            else{
                //Sufficient gesture
                if -value.translation.width > sufficientGesture{
                    //Can Hide
                    self.size = hiddenOffset
                }
                //Insufficient Gesture
                else{
                    //Remain in Position
                    self.size = presentedOffset
                }
            }
            
        })).animation(.spring())
        .onReceive(publisher.$present, perform: { bool in
            if(bool){
                self.size = presentedOffset
            }
            else{
                self.size = hiddenOffset
            }
        })
        .edgesIgnoringSafeArea(.vertical)

    }
    
}

struct swipe : View{
    let x = BooleanPublisher()
    
    var body : some View{
        ZStack{
            Text("Present")
                .onTapGesture(perform: {
                    x.presentMenu()
                })
                
            SlidingMenu(publisher: x, view: AnyView(VStack{HStack{Spacer()};Spacer()}))
        }
    }
}

struct SlidingMenu_Previews: PreviewProvider {
    static var previews: some View {
        swipe()
    }
}
