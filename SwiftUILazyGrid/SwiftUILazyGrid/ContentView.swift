//
//  ContentView.swift
//  SwiftUILazyGrid
//
//  Created by WN on 2023/11/3.
//

import SwiftUI

struct ContentView: View {
    
    private var appleSymbols = ["house.circle", "person.circle", "bag.circle", "location.circle", "bookmark.circle", "gift.circle", "globe.asia.australia.fill", "lock.circle", "pencil.circle", "link.circle"]

    let layout: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: layout, spacing: 12, content: {
                ForEach(0 ... 99, id: \.self) { idx in
                    let index = idx % appleSymbols.count
                    let name = appleSymbols[index]
                    Image(systemName: name)
                        .frame(minWidth: 80, maxWidth: .infinity, minHeight: 80)
                        .font(.system(size: 13))
                        .background(.gray)
                        .cornerRadius(6)
                }
            })
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
