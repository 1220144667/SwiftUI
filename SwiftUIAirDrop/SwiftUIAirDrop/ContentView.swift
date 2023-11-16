//
//  ContentView.swift
//  SwiftUIAirDrop
//
//  Created by WN on 2023/11/16.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animateCircle = false
    
    var body: some View {
        ZStack {
            Image(systemName: "antenna.radiowaves.left.and.right.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .foregroundStyle(.blue)
            Circle()
                .stroke()
                .frame(width: 340, height: 340)
                .foregroundStyle(.blue)
                .scaleEffect(animateCircle ? 1 : 0.3)
                .opacity(animateCircle ? 0 : 1)
            Circle()
                .stroke()
                .frame(width: 240, height: 240)
                .foregroundStyle(.blue)
                .scaleEffect(animateCircle ? 1 : 0.3)
                .opacity(animateCircle ? 0 : 1)
            Circle()
                .stroke()
                .frame(width: 150, height: 150)
                .foregroundStyle(.blue)
                .scaleEffect(animateCircle ? 1 : 0.3)
                .opacity(animateCircle ? 0 : 1)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 3).repeatForever(autoreverses: false)) {
                self.animateCircle.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
}
