//
//  ContentView.swift
//  ColourAtla
//
//  Created by WN on 2023/10/30.
//

import SwiftUI

struct ContentView: View {
    
    @State var cardItems: [CardModel] = []
    @State var showSearchBar = false
    @State var search = ""
    
    let JsonURL = "https://api.npoint.io/dc5a1718e0e958613ade"
    
    var body: some View {
        VStack {
            SearchBarView
            if self.cardItems.isEmpty {
                Spacer()
                ProgressView()
                Spacer()
            }else{
                CardListView
            }
        }
        .onAppear(perform: {
            self.getColors()
        })
    }
    
    //
    
    // MARK: 搜索颜色
    private func searchColor() {
        let query = search.lowercased()
        DispatchQueue.global(qos: .background).async {
            let filter = cardItems.filter { $0.cardColorRBG.lowercased().contains(query)}
            DispatchQueue.main.async {
                withAnimation(.spring()) {
                    self.cardItems = filter
                }
            }
        }
    }
    
    // MARK: 搜索
    private var SearchBarView: some View {
        TextField("search", text: $search, prompt: Text("搜索颜色值"))
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 8)
            }
            .padding(.horizontal, 10)
            .onChange(of: search, perform: { value in
                if value.isEmpty {
                    search = ""
                    getColors()
                } else {
                    searchColor()
                }
            })
    }
    
    // MARK：搜索icon
    private var SearchButtonView: some View {
        Button(action: {
            withAnimation(.easeOut) {
                showSearchBar.toggle()
            }
        }, label: {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.gray)
        })
    }
    
    private var CloseButtonView: some View {
        Button(action: {
            withAnimation(.easeOut) {
                search = ""
                getColors()
                showSearchBar.toggle()
            }
        }, label: {
            Text("取消")
                .foregroundStyle(.gray)
        })
    }
    
    private var CardListView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(cardItems, id: \.cardColorRBG) { item in
                VStack(spacing: 20) {
                    CardViewExamples(cardBGColor: Color.Hex(item.cardBGColor), cardColorName: item.cardColorName, cardColorRBG: item.cardColorRBG)
                }
            }
        }
    }
    
    func getColors() {
        guard let url = URL(string: JsonURL) else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: URLRequest(url: url)) { data, url, error in
            guard let jsonData = data else { return }
            do {
                let colors = try JSONDecoder().decode([CardModel].self, from: jsonData)
                self.cardItems = colors 
            } catch {
                print(error)
            }
        }
        .resume()
    }
}

struct CardViewExamples: View {
    
    var cardBGColor: Color
    var cardColorName: String
    var cardColorRBG: String
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center), content: {
            Rectangle()
                .fill(cardBGColor)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 110)
                .cornerRadius(8.0)
            HStack {
                VStack(alignment: .leading, spacing: 10, content: {
                    Text(cardColorName)
                        .font(.system(size: 17))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text(cardColorRBG)
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                })
                Spacer()
            }
            .padding()
        })
        .contextMenu(ContextMenu(menuItems: {
            Button(action: {
                UIPasteboard.general.string = cardColorName
            }, label: {
                Text("复制颜色值")
            })
        }))
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
