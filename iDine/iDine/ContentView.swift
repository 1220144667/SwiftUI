//
//  ContentView.swift
//  iDine
//
//  Created by WN on 2023/10/17.
//

import SwiftUI

struct ContentView: View {
    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    var body: some View {
        NavigationStack {
            List {
                ForEach(menu) { section in
                    Section(section.name) {
                        ForEach(section.items) { item in
                            NavigationLink(value: item) {
                                ItemRow(item: item)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: MenuItem.self, destination: { item in
                ItemDetail(item: item)
            })
            .navigationTitle("Menu")
            .listStyle(.grouped)
        }
    }
}

#Preview {
    ContentView()
}
