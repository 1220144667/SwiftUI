//
//  ContentView.swift
//  NotificationToast
//
//  Created by WN on 2023/11/16.
//

import SwiftUI

struct ContentView: View {
    
    @State var offset: CGFloat = -UIScreen.main.bounds.height/2 - 80
    
    var body: some View {
        ZStack {
            NotificationToastView()
                .offset(y: offset)
                .animation(.interpolatingSpring(stiffness: 120, damping: 10))
            Button(action: {
                if self.offset <= 0 {
                    self.offset += 180
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.offset -= 180
                    }
                }
            }, label: {
                Text("弹出通知")
            })
        }
    }
}

#Preview {
    ContentView()
}
