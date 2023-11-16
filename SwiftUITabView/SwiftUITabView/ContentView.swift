//
//  ContentView.swift
//  SwiftUITabView
//
//  Created by WN on 2023/11/16.
//

import SwiftUI

struct ContentView: View {
    
    @State var isFold: Bool = false
    
    let menuItems = ["首页", "沸点", "课程", "我的"]
    
    @State var selectedItem = 0
    
    @Namespace private var Transition
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
            if isFold {
                unfoldView()
            } else {
                foldView()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func foldView() -> some View {
        Image(systemName: "list.bullet")
            .font(.system(size: 24))
            .frame(minWidth: 0, maxWidth: 60, minHeight: 0, maxHeight: 60)
            .foregroundStyle(.black)
            .background(.white)
            .cornerRadius(30)
            .onTapGesture {
                withAnimation(.spring()) {
                    self.isFold.toggle()
                }
            }
            .matchedGeometryEffect(id: "fold", in: Transition)
    }
    
    func unfoldView() -> some View {
        HStack {
            Image(systemName: "xmark")
                .font(.system(size: 24))
                .foregroundStyle(.pink)
                .onTapGesture {
                    withAnimation(.spring()) {
                        self.isFold.toggle()
                    }
                }
                .matchedGeometryEffect(id: "fold", in: Transition)
            ForEach(menuItems.indices, id: \.self) { item in
                if item == selectedItem {
                    Text(menuItems[item])
                        .font(.system(size: 17))
                        .padding(.horizontal, 15)
                        .foregroundStyle(.pink)
                } else {
                    Text(menuItems[item])
                        .font(.system(size: 17))
                        .padding(.horizontal, 15)
                        .foregroundStyle(.black)
                        .onTapGesture {
                            selectedItem = item
                        }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60)
        .background(.white)
        .cornerRadius(30)
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
