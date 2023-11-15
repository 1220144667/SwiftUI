//
//  MainView.swift
//  iDine
//
//  Created by WN on 2023/10/17.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var order: Order
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
            OrderView()
                .tabItem {
                    Label("Order", systemImage: "square.and.pencil")
                }
        }
    }
}

#Preview {
    MainView().environmentObject(Order())
}
