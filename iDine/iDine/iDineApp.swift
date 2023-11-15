//
//  iDineApp.swift
//  iDine
//
//  Created by WN on 2023/10/17.
//

import SwiftUI

@main
struct iDineApp: App {
    
    @StateObject var order = Order()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(order)
        }
    }
}
