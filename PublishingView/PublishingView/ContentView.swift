//
//  ContentView.swift
//  PublishingView
//
//  Created by WN on 2023/11/16.
//

import SwiftUI

struct ContentView: View {
    
    @State var searchText = ""
    
    @State var showMaskView = false
    
    var body: some View {
        ZStack {
            VStack {
                topBarMenu()
                Spacer()
            }
            if showMaskView {
                MaskView(showMaskView: $showMaskView)
                SlideOutMenu(showMaskView: $showMaskView)
                    .transition(.move(edge: .bottom))
                    .animation(.interpolatingSpring(stiffness: 200.0, damping: 25.0, initialVelocity: 10.0), value: showMaskView)
            }
        }
    }
    
    func topBarMenu() -> some View {
        HStack(spacing: 15, content: {
            Button(action: {
                
            }, label: {
                Image(systemName: "video.square")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.gray)
            })
            
            TextField("TF", text: $searchText, prompt: Text("搜索文如秋雨"))
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).padding(.leading, 8)
                }
            
            // 新建发布
            Button(action: {
                self.showMaskView = true
            }, label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.blue)
            })
        })
        .padding(.horizontal, 15)
    }
}

#Preview {
    ContentView()
}
